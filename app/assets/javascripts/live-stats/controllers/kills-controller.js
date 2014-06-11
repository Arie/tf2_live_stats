'use strict';

liveStats.controller('KillsController', ['$scope', '$timeout', '$http', function($scope, $timeout, $http) {

  var get_stats = function(last_or_current) {
    if ($scope.matchId != undefined) { 
      $http.get('/kills/' + last_or_current + '/' + $scope.matchId + '?delay=' + $scope.timeDelay + '&' + new Date().getTime()).then(function(response) {
        set_stats(last_or_current, response.data);
      });
    };
  };
  var get_last_round = function(stats_fn) { 
    stats_fn('last');
    $timeout(function() {get_last_round(get_stats)}, $scope.delay);
  };
  var get_current_round = function(stats_fn) {
    stats_fn('current');
    $timeout(function() {get_current_round(get_stats)}, $scope.delay);
  };

  var set_stats = function(last_or_current, data) {
    if (last_or_current == 'last') { $scope.last_round = data };
    if (last_or_current == 'current') { $scope.current_round = data };
  };

  $scope.get_last_round     = get_last_round(get_stats);
  $scope.get_current_round  = get_current_round(get_stats);

}]);
