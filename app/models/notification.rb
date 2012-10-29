class NoNotification < Exception
end

class Notification
  include ActiveModel::Model

  attr_accessor :notifier, :body, :updated
  validates_presence_of :notifier, :body

  def set_notifier(*notifiers)
    @notifier = notifiers.select { |n| n.present? }.first
  end

  def updated?
    @updated == "1"
  end

  def deliver 
    case @notifier
    when Practice
      if updated?
        PracticeMailer.practice_updated(@notifier).deliver
      else
        PracticeMailer.practice_scheduled(@notifier).deliver
      end
    when Match
      if updated?
        MatchMailer.match_updated(@notifier).deliver
      else
        MatchMailer.match_scheduled(@notifier).deliver
      end
    else
      raise NoNotification
    end
  end
end

