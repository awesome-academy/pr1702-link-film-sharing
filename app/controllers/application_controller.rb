class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_search_params
  before_action :set_i18n_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, alert: exception.message
  end

  private

  def set_search_params
    @q = Post.ransack(params[:q])
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:picture])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def set_i18n_locale
    if params[:locale]
      if I18n.available_locales.include?(params[:locale].to_sym)
        I18n.locale = params[:locale]
      else
        flash.now[:notice] = params[:locale] + t("is_not_supported")
      end
    end
  end

  def default_url_options
    {:locale => I18n.locale}
  end
end
