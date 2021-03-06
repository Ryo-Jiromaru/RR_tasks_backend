class SessionsController < ApplicationController
    # サインイン
    def create
        @user = User.find_by(email: session_params[:email])

        # password_digestとsession_paramsのpasswordが一致しているか否かの条件分岐
        if @user && @user.authenticate(session_params[:password])
            logger.debug("ログインが走って成功してるパターン")
            login!
            render json: { logged_in: true, user: @user}
        else
            logger.debug("ログインが走って成功してるパターン")
            render json: {status: 401, errors: ['認証に失敗しました。', '正しいメールアドレス・パスワードを入力し直すか、新規登録を行ってください。']}
        end
    end

    #サインアウト
    def destroy
        reset_session
        render json: { status: 200, logged_out: true}
    end

    # ユーザーのログイン状態を追跡してreactへ返す
    def logged_in?
        if @current_user
            render json: { logged_in: true, user: @current_user }
        else
            logger.debug("ログイン状態でない")
            render json: { logged_in: false, message: 'ユーザーが存在しません'}
        end
    end

    @private
    
    def session_params
        params.require(:user).permit(:email, :password)
    end
end
