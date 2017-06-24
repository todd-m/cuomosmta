class ChangeTweetIdToBigintOnUsers < ActiveRecord::Migration
  def change
    change_column :users, :tweet_id, :bigint
  end
end
