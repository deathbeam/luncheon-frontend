luncheon.controller 'ErrorController', ($scope, $routeParams) ->
  $scope.code = $routeParams.code

  switch $scope.code
    when "403"
      $scope.heading = "K stránke nemáte prístup"
      $scope.message = "Prepáčte, ale nieste dostatočne oprávnený na návštevu
      tejto stránky. Skúste znova skontrolovať svoje prihlasovacie údaje alebo
      kliknite na tlačidlo nižšie pre návrat na domovskú stránku."
    when "404"
      $scope.heading = "Stránku sa nepodarilo nájsť"
      $scope.message = "Prepáčte, ale stránku ktorú hladáte sa buď nepodarilo
      nájsť alebo neexistuje. Skúste znova načítať stránku alebo kliknite na
      tlačidlo nižšie pre návrat na domovskú stránku."
    else
      $scope.code = 500
      $scope.heading = "Neočakávaná chyba"
      $scope.message = "Prepáčte, ale nastala chyba a vašu požiadavku sa
      nepodarilo dokončiť. Prosím, skúste znova neskôr alebo kliknite na
      tlačidlo nižšie pre návrat na domovskú stránku."
