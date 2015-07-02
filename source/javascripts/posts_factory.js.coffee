window.Posts ?= {}

window.Posts.PostsFactory = ($http, $q)->

  fetchPosts = (category, page) ->
    params = {}
    angular.extend(params, {category: category}) if !!category
    angular.extend(params, {page: page}) if page != 1

    $http({method: "GET", cache: true, url: PostsFactory.url, params: params}).then (response) =>
      @posts = response.data.posts
      @categories = response.data.categories
      return $q.reject("CNF") unless _categoryExists(@categories, category)
      response

  fetchCategories = ->
    $http({method: "GET", cache: true, url: PostsFactory.url}).then (response) =>
      @categories = response.data.categories
      response

  _categoryExists = (categories, category) ->
    return true if category.length == 0 or !categories
    categories.some((cat) -> cat.title == category)

  PostsFactory =
    url: "#{window.UtisakApiUrl}/posts"
    posts: @posts
    categories: @categories
    fetchCategories: fetchCategories
    fetchPosts: fetchPosts
