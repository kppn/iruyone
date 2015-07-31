class SessionsController < ApplicationController
  def new
  end

  def new_google
    state_token = SecureRandom.urlsafe_base64(32)
    session[:oauth_google] = {:state => state_token}
    url = "https://accounts.google.com/o/oauth2/auth?"\
          "client_id=280496559896-gmc3h1lji778147kn8ndbnqfh8278sok.apps.googleusercontent.com&"\
          "response_type=code&"\
          "scope=email%20profile&"\
          "redirect_uri=http://railsdevel.com:3000/oauth-google&"\
          "state=#{state_token}"
    redirect_to url
  end


  # GET /oauth-google
  # Google OAuth による認証後のコールバック呼び出し
  def oauth_google
    client_id     = "280496559896-gmc3h1lji778147kn8ndbnqfh8278sok.apps.googleusercontent.com"
    client_secret = "uA62q6axC75g1lIm5J9Y_xsu"

    if session[:oauth_google] && session[:oauth_google][:state].present?
      
      # CSRF 対策
      if session[:oauth_google][:state] == params[:state]
      
        if params[:code].present?
        
          # code を元に token 認証する
          response = Net::HTTP::post_form(URI.parse("https://accounts.google.com/o/oauth2/token"), {
            :code => params[:code],
            :client_id => client_id,
            :client_secret => client_secret,
            :redirect_uri => "http://railsdevel.com:3000/oauth-google",
            :grant_type => "authorization_code"
          })

          # token レスポンス
          result = JSON.parse(response.body)

          if result["expires_in"] > 0 && result["id_token"].present?

            api_response = Net::HTTP.get URI.parse("https://www.googleapis.com/oauth2/v1/tokeninfo?id_token=#{result['id_token']}")
            api_result = JSON.parse(api_response)
	    
	    puts api_result["issuer"]
	    puts api_result["issued_to"]
	    puts api_result["audience"]
	    puts api_result["verified_email"]

	    if api_result["verified_email"] == nil
	      puts "verified_email is nil"
	    end


            # if api_result["issuer"] == "accounts.google.com" && api_result["issued_to"] == client_id && api_result["audience"] == client_id && api_result["verified_email"]
            if api_result["issuer"] == "accounts.google.com" && api_result["issued_to"] == client_id && api_result["audience"] == client_id

              email = api_result["email"]

              puts "Signin: success Google OAuth '#{email}'"

              ActiveRecord::Base.transaction do
                # 既存のユーザーかどうか調べる
                # user = User.where("email = ?", email).first
                user = User.find_by(email: email.downcase) 

                if user.nil?
                  # 新規ユーザー登録（users テーブルというものがあると仮定）
                  user = User.create({:email => email})

                  puts "Signin: new user '#{email}'"
                end

                # セッションに認証情報を付与
                # session[:user_id] = user.id
		
		login user

              end
              
              #redirect_to root_path
              redirect_to root_url
              return
            end
          end
        end
      end
    end

    flash.now.alert = "何らかの理由で認証に失敗しました"
    # render :template => "index"
    render 'new'
  end


  def facebook_callback
    puts 'hello'
    puts env["omniauth.auth"]

    user = User.from_omniauth(env["omniauth.auth"])

    session[:user_id] = user.id
    login user

    redirect_to root_path, :notice => 'logined'
  end


  def twitter_callback
    user = User.from_omniauth(env["omniauth.auth"])

    session[:user_id] = user.id
    login user

    redirect_to root_path, :notice => 'logined'
  end


  def create
    user = User.find_by(email: params[:session][:email].downcase) 

    if user && user.authenticate(params[:session][:password])
      login user
      redirect_to root_url
    else
      flash.now[:error] = 'メール/パスワードが違います'
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to root_url
  end
end



