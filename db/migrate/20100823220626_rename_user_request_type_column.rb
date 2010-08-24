class RenameUserRequestTypeColumn < ActiveRecord::Migration
  def self.up
    rename_column :user_requests, :type, :request_type
  end

  def self.down
    rename_column :user_requests, :request_type, :type
  end
end
