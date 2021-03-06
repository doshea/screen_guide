class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate
  helper_method :air_tense, :datetime_ago_or_before

  def air_tense(some_time, omit_air = false)
    ago_or_before_hsh = datetime_ago_or_before(some_time)
    phrase = ago_or_before_hsh[:phrase]
    case ago_or_before_hsh[:tense]
    when 1
      "#{'Airs ' unless omit_air}in #{phrase}"
    when 0
      "#{'Airs ' unless omit_air}#{phrase}"
    when -1
      "#{'Aired ' unless omit_air}#{phrase} ago"
    end
  end

  def datetime_ago_or_before(some_time)
    now = DateTime.now
    
    time_diff = (some_time - now).to_i.abs
    year_diff = (time_diff/365).floor
    time_diff = time_diff - (year_diff * 365)
    month_diff = (time_diff/30).floor
    time_diff = time_diff - (month_diff * 30)
    day_diff = time_diff

    tense = 0
    if year_diff > 1
      phrase = "#{year_diff} years"
    else
      # month_diff = (now.month - some_time.month).abs
      if year_diff == 1
        if month_diff > 0
          year_decim = ((year_diff + month_diff/12.0)*10).ceil/10.0
          phrase = "#{year_decim} years"
        else
          phrase = '1 year'
        end
      else
        if month_diff > 1
          phrase = "#{month_diff} months"
        else
          # day_diff = (now.day - some_time.day).abs
          if month_diff == 1
            if day_diff > 0
              month_decim = ((month_diff + day_diff/30.0)*10).ceil/10.0
              phrase = "#{month_decim} months"
            else
              phrase = '1 month'
            end
          else
            # day_diff = (now.day - some_time.day).abs
            if day_diff > 0
              phrase = ActionController::Base.helpers.pluralize(day_diff, 'day')
            else
              phrase = 'Today'
              tense = 0
            end
          end
        end
      end
    end
    unless phrase == 'Today'
      tense = ((some_time > now) ? 1 : -1)
    end
    return {phrase: phrase, tense: tense}
  end

  private
  def authenticate
    @current_user = User.find_by_auth_token( cookies[:auth_token]) if cookies[:auth_token]
    @current_user ||= session[:user_id].present? ? User.find(session[:user_id]) : nil
  end

  def ensure_logged_in
    render text: 'Account Required' unless @current_user
  end
  def ensure_admin
    render text: 'Not Authorized' if (@current_user.nil? || !@current_user.is_admin)
  end


  
end
