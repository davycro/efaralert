class DropV1Tables < ActiveRecord::Migration
  def up
    %w(townships head_efars dispatch_messages dispatches).each do |table_name|
      drop_table table_name.to_sym
    end
  end

  def down
    raise "cant go back!"
  end
end
