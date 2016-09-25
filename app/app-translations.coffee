luncheon.config ($translateProvider) ->
  $translateProvider.translations 'sk',
    # Page headers
    SITE: 'Luncheon'
    LOGIN: 'Prihlásenie'
    USER: 'Zoznam obedov'
    ERROR: 'Chyba'
    LOADING: 'Načítavam...'
    # Login Page
    LOGIN_INPUT_USER: 'Email alebo čiarový kód'
    LOGIN_INPUT_PASS: 'Heslo (potrebné iba pri emaile)'
    # User Page
    USER_MEAL: 'Hlavné jedlo'
    USER_SOUP: 'Polievka'
    USER_MAKE_ORDER: 'Objednať obed'
    USER_CANCEL_ORDER: 'Zrušiť objednávku'
    # Tooltips
    LOGOUT_TOOLTIP: 'Odhlásiť sa'
    LOGIN_TOOLTIP: 'Prihlásiť sa'
 
  $translateProvider.preferredLanguage 'sk'
  $translateProvider.useSanitizeValueStrategy 'escape'