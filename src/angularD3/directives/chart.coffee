angular.module('ad3').directive 'd3Chart', ->
  restrict: 'EA'
  scope: true

  controller: ['$scope', '$element', '$attrs', '$window', '$timeout', ($scope, $el, $attrs, $window, $timeout) ->
    scales = $scope.scales = {}
    elements = $scope.elements = []
    binding = $scope.binding = $attrs.data

    @margin = $scope.$eval($attrs.margin) or { top: 10, right: 10, bottom: 10, left: 10 }
    svg = d3.select($el[0]).append('svg').attr('class', "d3")
      .attr("width", "100%")
      .attr("height", "100%")

    @width = -> $el[0].scrollWidth
    @height = -> $el[0].scrollHeight
    @innerWidth = -> @width() - @margin.left - @margin.right
    @innerHeight = -> @height() - @margin.top - @margin.bottom

    chart = svg.append("g")
      .attr("transform", "translate(" + @margin.left + "," + @margin.top + ")")

    @getChart = () -> chart
    @addScale = (name, scale) -> scales[name] = scale
    @getScale = (name) -> scales[name].scale
    @registerElement = (el) -> elements.push el

    debounce = null
    @redraw = ->
      data = $scope.$eval(binding)
      return if debounce
      debounce = $timeout =>
        debounce = null
        for name, scale of scales
          scale.redraw(data)
        for element in elements
          element.redraw(data)
      , $attrs.updateInterval or 200
    $window.addEventListener 'resize', @redraw
    $scope.$watch binding, @redraw, true

    return
  ]
