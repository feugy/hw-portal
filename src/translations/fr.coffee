I18n.translations.fr =
  # i18n pluralization, number, currency and date configuration
  date:
    formats:
      default: '%d/%m/%Y'
      short: '%-d %b'
      long: 'le %-d %B %Y'
    day_names: ['dimanche', 'lundi', 'mardi', 'mercredi',
      'jeudi', 'vendredi', 'samedi']
    abbr_day_names: ['dim.', 'lun.', 'mar.', 'mer.', 'jeu.', 'ven.', 'sam.']
    month_names: ['~', 'janvier', 'février', 'mars', 'avril', 'mai',
      'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre']
    abbr_month_names: ['~', 'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.']

  time:
    formats:
      default: '%d/%m/%Y %H:%M'
      time: '%H:%M'
      short: '%d %b %H:%M'
      long: '%A %d %B %Y %H:%M:%S %Z'
      only_second: '%S'
    am: 'matin'
    pm: 'après-midi'

  number:
    format:
      precision: 3
      separator: ','
      delimiter: ' '
    currency:
      format:
        unit: '€'
        precision: 2
        format: '%n %u'

  # Custom keys
  btn:
    logIn: 'Se connecter'
    signIn: 'Créer un compte'
    sortByDeltas: 'par deltas'
    sortByScore: 'par score'
    sortByTrophies: 'par trophées'

  err:
    loginMissing: 'Merci d\'entrer ton email'
    passwordMissing: 'Merci d\'entrer ton mot de passe'
    passwordConfirmDiffers: 'Confirme de nouveau ton mot de passe'

  lbl:
    challengeLimit: 'Limite : '
    challengePointGain: '+ {{points} pts'
    activityPoints: '{{points} pts'
    confirmMajority: 'J\'ai plus de 16 ans et j\'ai lu et accepté les conditions d\'utilisation de Huby Woky'
    logIn: 'Ou utiliser ton compte Huby Woky'
    logInWith: 'Connecte toi avec'
    noActivity: 'Il était temps que tu reviennes !'
    noChallenge: 'Tout va bien, continue comme ça.'
    noResults: 'Aucun résultat'
    signIn: 'Crée ton compte Huby Woky'
    scrollEnds: 'Tous les résultats sont affichés'
    scrollLoading: 'Chargement en cours...'

  msg:
    majorityNeeded: 'Si tu as moins de 16 ans, demande à tes parents de créer ton compte.'

  nav:
    challenges: 'Mes challenges'
    connect: 'Se connecter'
    home: 'Accueil'
    rankings: 'Classements'

  plh:
    email: 'Ton email'
    password: 'Ton mot de passe'
    passwordConfirm: 'Confirme ton mot de passe'

  ttl:
    app: 'Huby Woky'
    challenges: 'Challenges'
    deltasRanking: 'Classement par deltas'
    generalRanking: 'Classement général'
    home: 'Heureux de te revoir {{pseudo}} !'
    logIn: 'Déjà membre ?'
    newChallenge: 'Nouveau challenge : {{name}} !'
    recentActivity: 'Activité récente'
    signIn: 'Nouveau membre ?'
    trophiesRanking: 'Classement des trophées'
    welcome: 'Une terrible menace sommeille dans les ombres...'

  challenges:
    'first-prey':
      name: 'Première proie'
      details: 'Capture un de delta appartenant à un autre joueur'
      icon: 'asterisk'
    'come-back':
      name: 'De retour'
      details: 'Récupère un detla que tu avais perdu'
      icon: 'refresh'
    'level-up':
      name: 'Level up'
      details: 'Améliore de 5 places ta position dans le classement général'
      icon: 'arrow-up'
    'complete-set':
      name: 'Enfin complet...'
      details: 'Récupère tous les delta d\'un set'
      icon: 'arrows-compress'
    'complete-scene':
      name: 'Ils sont tous là'
      details: 'Récupère tous les delta d\'un scene'
      icon: 'arrows-in'
    'double-set':
      name: 'Jumeaux'
      details: 'Possède tous les delta d\'un même set en double'
      icon: 'page-copy'
    'double-scene':
      name: 'Multitude'
      details: 'Possède tous les delta d\'un même scene en double'
      icon: 'page-multiple'
    hunter:
      name: 'Chasseur'
      details: 'Récupère tous les animaux de la jungle'
      icon: 'target'
    killer:
      name: 'Tueur'
      details: 'Récupère 12 delta d\'un même joueur dans la journée'
      icon: 'torso'
    'serial-killer':
      name: 'Tueur en série'
      details: 'Récupère 12 delta de trois joueurs dans la journée'
      icon: 'torsos-all'
    jungle:
      name: 'Maitre de la jungle'
      details: 'Possède tous les delta de la scène "Jungle"'
      icon: 'trees'

  activities:
    'delta-won':
      name: 'Nouveaux deltas'
      icon: 'delta'
    'delta-lost':
      name: 'Deltas perdus'
      icon: 'delta'
    'challenge-completed':
      icon: 'trophy'
