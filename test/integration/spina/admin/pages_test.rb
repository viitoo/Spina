require 'test_helper'

module Spina
  module Admin
    class PagesTest < ActionDispatch::IntegrationTest
      setup do
        @routes = Engine.routes
        post "/admin/sessions", params: {email: spina_users(:bram).email, password: "password"}
      end

      test "new page form" do
        get "/admin/pages/new"
        assert_select '#page_form'
      end

      test "create new page" do
        post "/admin/pages", params: {page: {title: "A new page"}}
        follow_redirect!
        assert_select '.breadcrumbs', text: /A\snew\spage\z/
      end

      test "create new page without title" do
        post "/admin/pages", params: {page: {title: nil}}
        assert_select '.field_with_errors'
      end

      test "create concept page" do
        post "/admin/pages", params: {page: {title: "A new page", draft: true}}
        follow_redirect!
        assert_select '.breadcrumbs', text: /A\snew\spage\z/
        get "/admin/pages"
        assert_select '.dd-item-inner small', text: '(draft)'
      end
    end
  end
end