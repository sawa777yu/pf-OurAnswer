# frozen_string_literal: true

require 'rails_helper'

describe '投稿のテスト', type: :system do

  let!(:user) { FactoryBot.create(:user) }
  let!(:post) { FactoryBot.create(:post,title:'hoge',body:'body', user: user) }
  let!(:genre) { FactoryBot.create(:genre) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: 'test@example.com'
    fill_in 'user[password]', with: 'password'
    click_button 'ログイン'
  end


  describe 'トップ画面（root_path）のテスト' do
    before do
      visit root_path
    end
    context '表示の確認' do
      it 'トップ画面（root_path）に通知一覧へのリンクが表示されているか' do
        expect(page).to have_link "通知", href: notifications_path
      end
      it 'root_pathが"/"であるか' do
        expect(current_path).to eq('/')
      end
    end
  end

  describe '投稿画面のテスト' do
    before do
      visit new_post_path
    end
    context '表示の確認' do
      it 'new_post_pathが"/posts/new"であるか' do
        expect(current_path).to eq('/posts/new')
      end
      it '新規投稿ボタンが表示されているか' do
        expect(page).to have_button '新規投稿'
      end
    end
    context '投稿処理のテスト' do
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'post[reference_url]', with: Faker::Internet.url
        select '玄関', from: 'post_genre_id',match: :first
        fill_in 'post[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'post[body]', with: Faker::Lorem.characters(number:15)
        click_button '新規投稿'
        expect(page).to have_current_path post_path(Post.last)
      end
    end
  end

  describe '詳細画面のテスト' do
    before '詳細画面への遷移' do
      visit post_path(post)
    end
    context '表示のテスト' do
      it '投稿タイトルと投稿内容詳細が表示されているか' do
        expect(page).to have_content post.title
        expect(page).to have_content post.body
      end
      it '記事編集ボタンが表示されているか' do
        expect(page).to have_link '記事編集'
      end
    end
    context 'ボタンの遷移先の確認' do
      it '記事編集ボタンの遷移先は編集画面か' do
        click_link '記事編集'
        expect(current_path).to eq('/posts/' + post.id.to_s + '/edit')
      end
    end
  end

  describe '編集画面のテスト' do
    before '編集画面への遷移' do
      visit edit_post_path(post)
    end
    context '表示の確認' do
      it '編集前のタイトルと詳細がフォームに表示されている' do
        expect(page).to have_field 'post[title]', with: post.title
        expect(page).to have_field 'post[body]', with: post.body
      end
      it '変更を保存ボタンが表示される' do
        expect(page).to have_button '変更を保存'
      end
    end
    context 'ボタンの遷移先の確認' do
      it '変更を保存の遷移先は詳細画面か' do
        click_button '変更を保存'
        expect(current_path).to eq('/posts/' + post.id.to_s)
      end
    end
  end
end