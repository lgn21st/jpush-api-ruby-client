require 'test_helper'

module Jpush
  module Api
    class PushTest < Jpush::Test

      def setup
        @push_payload = Push::PushPayload.new(platform: 'all', audience: 'all', notification: 'hello from schedule api').build
        @schedule_payload = Schedule::SchedulePayload.new('jpush', Time.new(2020), @push_payload).build
        @pusher = @@jPush.pusher
        @schedules = @@jPush.schedules
      end

      def test_create
        response = @schedules.create(@schedule_payload)
        assert_equal 200, response.http_code
        body = response.body
        assert_equal 2, body.size
        assert_equal 'jpush', body['name']
      end

      def test_tasks
        response = @schedules.tasks
        assert_equal 200, response.http_code
        assert_instance_of Hash, response.body
        assert_equal 4, response.body.size
      end

      def test_show
        assert_raises Utils::Exceptions::JpushResponseError do
          @schedules.show('INVALID_SCHEDULE_ID')
        end

        schedule_id = @schedules.tasks.body['schedules'].first['schedule_id']
        response = @schedules.show(schedule_id)
        assert_equal 200, response.http_code
        body = response.body
        assert_equal 5, body.size
      end

      def test_update
        assert_raises  Jpush::Utils::Exceptions::JpushResponseError do
          @schedules.update('INVALID_SCHEDULE_ID', name: 'jpush_ruby')
        end
        schedule_id = @schedules.tasks.body['schedules'].first['schedule_id']
        response = @schedules.update(schedule_id, name: 'jpush_ruby')
        assert_equal 200, response.http_code
      end

      def test_delete
        schedule_id = @schedules.tasks.body['schedules'].first['schedule_id']
        response = @schedules.delete(schedule_id)
        assert_equal 200, response.http_code
      end

    end
  end
end