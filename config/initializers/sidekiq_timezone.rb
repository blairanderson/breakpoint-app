module SidekiqTimezone
  class Client
    def call(worker_class, msg, queue)
      if User.current_user.present?
        msg['current_user_id'] ||= User.current_user.id
      end

      yield
    end
  end

  class Server
    def call(worker_class, msg, queue)
      if msg.has_key?('current_user_id')
        user = User.find(msg['current_user_id'])
        Time.use_zone(user.time_zone) do
          yield
        end
      else
        yield
      end
    end
  end
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add SidekiqTimezone::Client
  end
end

Sidekiq.configure_server do |config|
  config.client_middleware do |chain|
    chain.add SidekiqTimezone::Client
  end

  config.server_middleware do |chain|
    chain.add SidekiqTimezone::Server
  end
end

