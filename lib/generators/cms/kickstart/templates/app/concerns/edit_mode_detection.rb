module EditModeDetection
  extend ActiveSupport::Concern

  included do
    before_filter :detect_editing_allowed
  end

  private

  def detect_editing_allowed
    session[:editing_allowed] = current_user.admin?
  end

  def self.editing_allowed?(env)
    env['rack.session'][:editing_allowed]
  end

  def editing_allowed?
    self.class.editing_allowed?(request.env)
  end
end

