# frozen_string_literal: true

require 'rails_helper'

describe 'モデルのテスト', type: :model do
  it '有効な投稿内容の場合は保存されるか' do
    # 下記はbuildだとエラーになる。
    # https://seiya2130.hatenablog.com/entry/2020/03/21/160818
    # buildはメモリ上で保存するためbuildのほうが処理が早いが
    # 当アプリの場合は（恐らく）アソシエーションの関係でDBを参照する必要があるため
    # createじゃないとテストできない。
    expect(FactoryBot.create(:post)).to be_valid
  end
end