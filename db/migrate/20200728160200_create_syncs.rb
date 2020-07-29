class CreateSyncs < ActiveRecord::Migration[5.1]
  def change
    create_table :syncs do |t|
      t.references :user, foreign_key: true

      t.text :content

      t.timestamps
    end
  end
end
