module ActiveAdmin
  module Views
    class Footer < Component

     private

      def powered_by_message

        para "Copyright #{Date.today.year} Yeti Admin ver: #{Yeti::Application.config.app_build_info.fetch('version', 'unknown')}. Routing ver #{Yeti::ActiveRecord::DB_VER}. CDR ver #{Cdr::Base::DB_VER}.".html_safe

      end

    end
  end
end
