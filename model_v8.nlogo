globals

[ nest-energy                              ;; variable for measuring the colonys overall foraging success
  time-to-finish                           ;; time to finish task
  ind-ant-times-visited                    ;; mean number of visits made by all ants
  total-num-food-visits                    ;; total number of visits made by all ants
  ;total-num-food-visits-new                ;; total number of visits made by all ants - checking
  total-num-food-visits-returned
  total-num-food-visits-returned-ui
  total-num-food-visits-returned-i
  ind-ant-times-disappointed               ;; mean number of times ants were disappointed and walked back home
  total-num-ants-visited                   ;; total number of ants that made visits to food
  distance-walked-list                     ;; list of the individual distances walked by ants
  mean-route-efficiency                    ;; mean foraging efficiency
  total-foraging-distance                  ;; sum of all distances walked by every single ant over the whole foraging duration
  total-foraging-distance-ui
  total-foraging-distance-i
  total-steps-taken
  total-steps-taken-ui
  total-steps-taken-i
  forager-energy-ui
  forager-energy-i
  number-tr
  num-breakup
  benefit-per-ant
  cost-per-ant
  benefit-per-active-ant
  cost-per-active-ant
  total-distace-walked
  total-num-active-ants

]


breed [recruits recruit]                                       ;; waiting for Tandemstarters to begin Tandem
breed [scouts scout]                                           ;; outgoing ants
breed [waiting-scouts waiting-scout ]                          ;; unsuccessful scout waiting at the nest for going out again
breed [returning-scouts returning-scout]                       ;; scouts returning to the nest after being to far to long out
breed [drinking-ants drinking-ant ]                            ;; all ants at food-sources, drinking
breed [unsatisfied-foragers unsatisfied-forager]               ;; foragers that did not complete feeding and breeds (-50% of lost-TRS) after search time for food source is over
breed [happy-successful-foragers-1 happy-successful-forager-1 ];; happy foragers returning to nest from food source 1
;breed [happy-successful-foragers-2 happy-successful-forager-2 ];; happy foragers returning to nest from food source 2
breed [successful-foragers-1 successful-forager-1]              ;; successful foragers satisfied with food source 1, memory to return to it
;breed [successful-foragers-2 successful-forager-2]             ;; successful foragers satisfied with food source 2, memory to return to it
breed [Tandemstarters-1 Tandemstarter-1]                       ;; potential Tandemstarters satisfied with food source 1, memory to return to it
;breed [Tandemstarters-2 Tandemstarter-2]                       ;; potential Tandemstarters satisfied with food source 2, memory to return to it
breed [Tandemleaders-1 Tandemleader-1]                         ;; Tandemleader to food source 1
;breed [Tandemleaders-2 Tandemleader-2]                         ;; Tandemleader to food source 2
breed [Tandemfollowers-1 Tandemfollower-1]                     ;; Tandemfollower to food source 1
;breed [Tandemfollowers-2 Tandemfollower-2]                     ;; Tandemfollower to food source 2
breed [lost-TRs lost-TR ]                                      ;; Tandemfollower that lost food source direction

turtles-own

[time-disappoint
  feeding-time                                                 ;; time an ant feeds, default 120 ticks
  angle-perception
  distance-perception
  tr-walk-speed
  tr-distance-perception
  angle-general
  velocity-outside
  prob-of-leading
  prob-of-following
  infection-status
  cost-infection
  scouts-time                                                  ;; time of a scout for scouting, default 600 ticks
  nest-stay-time                                               ;; time an ant stays in the nest, 60 ticks for all breeds except Tandemstarters (120 ticks)
  search-time                                                  ;; time a successful forager searches for "her" foodsource. When over, then memory loss/give up and scouting again, default 120 ticks
  forager-timer                                                ;; timer for foragers (scouts, recruits and followers)
  times-visited                                                ;; number of times ant visited the food
  times-visited-returned
  previous-location
  times-disappointed                                           ;; number of times ant went back home disappointed
  forager-energy                                               ;; energy of a forager
  forager-energy-tracker
  happiness                                                   ;; happiness of a forager
  foraged?                                                     ;; did the ant forage?
  left-nest?                                                   ;; did the ant leave the nest to forage?
  reorient-time
  distance-walked
  prob-of-recruitment
  reorient-home
  distance-tr-pair
  walk-speed-tr-pair
  leader-id
  tandem-left
  tandem-right
]

patches-own
[ nest?                                                        ;; true on nest patches, false elsewhere
  if-food?                                                     ;; true on FS patches, false elsewhere
  nest-scent                                                   ;; scent of nest, stronger when nearer to the nest
  FS-number                                                    ;; number of the food sources (1 or 2)
  ;FS-scent-1                                                   ;; scent of food source 1, number that is higher closer to it
 ; FS-scent-2                                                   ;; scent of food source 2, number that is higher closer to it
  FS-timer-1                                                   ;; time till the vanished food source 1 reappears. Adjustable via slider FS-timer, default 1/10 of experimenatl durance
 ; FS-timer-2                                                   ;; time till the vanished food source 2 reappears. Adjustable via slider FS-timer, default 1/10 of experimenatl durance  ;; time till FS-scent-2 runs out, adjustable via slider FS-timer, default 300 ticks
  FS-quality                                                   ;; quality of food sources: if reward = 0.75 it has a high quality (1), else it has low quality (0)
  FS-energy ]                                                  ;; energy of food source: if empty then the FS vanishes

;;;;;;;;;;;;;;;;;;;;;;;;
;;; Setup procedures ;;;
;;;;;;;;;;;;;;;;;;;;;;;;

to setup
  clear-all                                                     ;; (re)creation of an empty arena
  set total-distace-walked 0
  set num-breakup 0
  set number-tr 0
  set total-num-food-visits 0
  set total-num-food-visits-returned 0
  set total-num-food-visits-returned-ui 0
  set total-num-food-visits-returned-i 0
  set total-foraging-distance 0
  set total-foraging-distance-ui 0
  set total-foraging-distance-i 0
  set forager-energy-ui 0
  set forager-energy-i 0
  set total-steps-taken 0
  set total-steps-taken-ui 0
  set total-steps-taken-i 0
  set total-num-ants-visited 0
  set ind-ant-times-visited 0
  set total-num-active-ants 0
  set ind-ant-times-disappointed 0
  set distance-walked-list [ ]
  set mean-route-efficiency 0
  set-default-shape turtles "bug"                               ;; form of all agents shall be ants
  create-scouts number-of-scouts                                ;; an adjustable number of scouts will be created
  create-recruits colony-size - number-of-scouts      ;; number of recruits is dependent on nuber of scouts and this ratio can be manipulated; default is 9% of foragers are scouts
  create-infected-ants (disease-prevalence * colony-size)             ;; setting infection status of turtles
  ask turtles                                                     ;; all agents at the start of the simulation have the same
      [ ;pen-down
         set size 2                                                 ;; size
        set foraged? 0
        set previous-location "nest"
        set left-nest? 0
        set angle-general 90
        set reorient-time 0
        set reorient-home 0
        set times-visited 0
        set times-visited-returned 0
        set times-disappointed 0
        set distance-walked 0
        set forager-energy 0                                        ;; 0 energy
        set forager-energy-tracker 0
        set feeding-time 120                                        ;; same feeding time
        set search-time FS-searching-time                       ;; same search time for a food source
        set nest-stay-time 60                                       ;; and their nest stay time is initially set for the (adjustable) unloading time
        set prob-of-recruitment 0.4


         ifelse cost-perception-distance = 1 [
            if infection-status = 0 [ set distance-perception distance-SA]
            if infection-status = 1 [ set distance-perception distance-SA * (1 - cost-of-infection)]
          ]
          [ set distance-perception distance-SA
          ]
          ifelse cost-walk-speed = 1 [
            if infection-status = 0 [ set velocity-outside walk-SA]
            if infection-status = 1 [ set velocity-outside walk-SA * (1 - cost-of-infection)]
          ]
          [ set velocity-outside walk-SA
          ]
          ifelse cost-perception-angle = 1 [
            if infection-status = 0 [ set angle-perception angle-SA]
            if infection-status = 1 [ set angle-perception angle-SA + cost-of-infection * ( angle-general - angle-SA)]
          ]
          [ set angle-perception angle-SA
          ]
          ifelse cost-leading = 1 [
            if infection-status = 0 [                                    ;;; both prob of leaving and prob of following are affected by the presence of infection
              set prob-of-leading leading-SA
              set prob-of-following 0.25
            ]
            if infection-status = 1 [
              set prob-of-leading leading-SA * (1 - cost-of-infection)
              set prob-of-following 0.25 * (1 - cost-of-infection)
            ]
          ]
          [ set prob-of-leading leading-SA
            set prob-of-following 0.25
          ]
          ifelse cost-disappointment = 1 [
            if infection-status = 0 [ set time-disappoint disappointment-SA]
            if infection-status = 1 [ set time-disappoint disappointment-SA * (1 - cost-of-infection)]
          ]
          [ set time-disappoint disappointment-SA
          ]
        ifelse breed = scouts                                          ;; if they are scouts,
        [ set color red ]                                       ;; they shall be red
        [ set color grey ]

  ]                                    ;; else they are recruits and are grey

  setup-patches                                                 ;; orders to create the world

  reset-ticks                                                   ;; reset tick counter
end

to setup-patches
ask patches
[ setup-nest                                                     ;; nest is created
  setup-food                                                     ;; food sources are created
  color-patch ]                                                  ;; nest and food sources are given color
end

to setup-nest                                                    ;; creation of nest
  set nest? (distancexy 0 0) < nest-size                           ;; set nest?-variable: true inside the nest, false elsewhere
  set nest-scent 200 - distancexy 0 0                              ;; spread a nest-scent over the whole arena which is stronger near the nest
  set nest-energy 0                                                ;; initial nest energy is set to 0
end

to setup-food                                                    ;; setup of food sources with scent and quality

if (distancexy -41 0) < Food-size-one                            ;; creation of a food source at 20 patches distance from the left outer edge of the nest
[ set FS-number 1                                                ;; give it the number 1
   ifelse reward-FS-1 = 0.75                                     ;; if it is the food source 1 and the (adjustable) reward is high enough then
  [ set  FS-quality  1                                           ;; it has a high quality
    set FS-energy food-energy-high ]                             ;; and a high energy
  [ set  FS-quality  0                                           ;; it has a low quality
      set FS-energy food-energy-low ] ]                          ;; and low energy
  ;set FS-scent-1 200 - distancexy -41 0                          ;; scent of food source 1

;if (distancexy 31 0) < Food-size-two                             ;; creation of food source 2 at 20 patches distance from the right outer edge of the nest
;[ set FS-number 2                                                ;; give it the number 2
;   ifelse reward-FS-2 = 0.75                                     ;; if it is the food source 2 and the (adjustable) reward is high enough then
;  [ set  FS-quality  1                                           ;; it has a high quality
;    set FS-energy food-energy-high ]                             ;; and a high energy
;  [ set  FS-quality  0                                           ;; it has a low quality
;      set FS-energy food-energy-low ] ]                          ;; and low energy
;  set FS-scent-2 200 - distancexy 31 0                           ;; scent of food source 2

ifelse FS-number > 0                                             ;; if it is a food source
  [ set if-food? true ]                                          ;; it has food to offer
  [ set if-food? false ]                                         ;; else: it has no food to offer and is just a regular patch
  set FS-timer-1  FS-timer                                       ;; set time till the vanished food source 1 reappears to the adjustable FS-timer
  ;set FS-timer-2  FS-timer                                       ;; set time till the vanished food source 2 reappears to the adjustable FS-timer
end

to color-patch                                                   ;; colour the world
ifelse nest?                                                     ;; nest is violet
[ set pcolor violet ]
[ if FS-number > 0                                               ;; if there are food sources, their color is
[ set pcolor white ] ]                                           ;; white
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; START OF REPEATED ACTIONS ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to go

  ask turtles
 [ if nest?
    [ set happiness 0
      set reorient-time 0
  ]
    if if-food? = true [ set reorient-home 0 ]
  ]                                         ;; reset happiness for all agents to 0 (becoming ready for another foraging trip)

;;;;;;;;;;;;;;;;;;;;;;;;
;;; RECRUITS AT NEST ;;;
;;;;;;;;;;;;;;;;;;;;;;;;

ask recruits                                                      ;; recruits shall be
[  set color grey                                                 ;; grey
if nest?                                                          ;; in the nest
[  wiggle angle-general                                                         ;; randomly change direction inside the nest
   set previous-location "nest"
   nest-stay                                                      ;; and walk slowly inside the nest
   set forager-timer forager-timer + 1 ] ]                        ;; Timer for time spend waiting in the nest advances

;;;;;;;;;;;;;;
;;; SCOUTS ;;;
;;;;;;;;;;;;;;

  ask scouts
      [ set color red                                                ;; all scouts are of red colour
        pen-up
        scouting                                                     ;; general procedure of scouts
        if if-food? = true                                                ;; if food is found
        [ ask scouts-here                                                 ;; scouts at a FS
          [ output-show forager-timer                                     ;; trigger the timer to display their time spend scouting
            set breed drinking-ants                                       ;; become drinking-ants
            stop ] ]                                                      ;; do not "overrun" small food sources
        if scouts-time >= time-disappoint                                     ;; if they are to long out
        [ decision-of-foraging ] ]                                ;; face decision wether to go on scouting or return to nest

  ask returning-scouts                                            ;; returning scouts
      [ return-to-nest                                              ;; return to the nest

        if nest?                                                         ;; at the nest
        [ set times-disappointed times-disappointed + 1
          set distance-walked 0
          set breed waiting-scouts   ] ]                                  ;; scouts from unsuccessful scouting wait at nest

  ask waiting-scouts                                              ;; scouts waiting at the nest
  [ nest-stay                                                     ;; and walk slowly inside the nest
    set previous-location "nest"
    set nest-stay-time nest-stay-time - 1                         ;; time they stay in the nest counts down
    ifelse nest-stay-time <= 0                                        ;; if their nest stay time is over
    [ set breed scouts                                              ;; become scouts again
      reset-times ]                                               ;; reset internal timers
    [ nest-stay ] ]                                                   ;; if time is not over, stay at nest as waiting scouts

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;; OTHER FORAGERS ;;;
  ;;;;;;;;;;;;;;;;;;;;;;

  ask drinking-ants                                               ;; ants at a FS
  [ set color yellow                                              ;; are yellow in color
    set foraged? 1
    ifelse if-food? = true                                        ;; if there is food
    [ set previous-location "food"
      feed
      ]                                                      ;; feed on it
    [ set previous-location "nest"
      set breed unsatisfied-foragers ] ]                          ;; become an unsatisfied forager

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; HAPPY ANTS RETURN TO NEST ;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ask happy-successful-foragers-1                                   ;; ants happy with food source 1
  [ ;pen-down
    pen-up
    set color green                                                ;; are green
    ifelse nest?                                                  ;; if there are at nest
    [  nest-stay                                                    ;; walk slowly
      set nest-stay-time nest-stay-time - 1 ]                      ;; time they stay in the nest counts down
    [ return-to-nest ]                                             ;; else they are outside and return to the nest
    if nest? and nest-stay-time = 0                                   ;; if they are at the nest and their nest stay time is over
    [ unload                                                          ;; they give their forager energy (positive or negative value) to the nest (changing nest energy)
      set times-visited-returned times-visited-returned + 1
      set previous-location "nest"
      decision-of-recruitment-1 ] ]                                   ;; face decision whether to recruit to food source 1 or not

  ;ask happy-successful-foragers-2                                   ;; ants happy with food source 2
  ;[  set color green                                                ;; are green
  ;    ifelse nest?                                                  ;; if there are at nest
  ;  [  nest-stay                                                    ;; walk slowly
  ;     set nest-stay-time nest-stay-time - 1 ]                      ;; time they stay in the nest counts down
  ;   [ return-to-nest ]                                             ;; else they are outside and return to the nest
  ;if nest? and nest-stay-time = 0                                   ;; if they are at the nest and their nest stay time is over
  ;[ unload                                                          ;; they give their forager energy (positive or negative value) to the nest (changing nest energy)
  ;  decision-of-recruitment-2 ] ]                                   ;; face decision whether to recruit to food source 2 or not

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; UNSATISFIED ANTS RETURN TO NEST ;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ask unsatisfied-foragers
  [ pen-up
    set color brown                                                ;; unsuccessful ants are brown
    if patch-ahead 1 = nobody                                     ;; if they encounter a wall (non-patch)
    [ rt 180 ]                                                      ;; change direction by 180°
    ifelse nest?                                                  ;; if there are at nest
    [  nest-stay                                                    ;; walk slowly
      set nest-stay-time nest-stay-time - 1 ]                      ;; time they stay in the nest counts down
    [ return-to-nest ]                                             ;; else they are outside and return to the nest
    if nest? and nest-stay-time = 0                                   ;; if they are at the nest and nest stay time is over
    [ unload                                                          ;; they give their forager energy (positive or negative value) to the nest (changing nest energy)
      if previous-location = "food" [set times-visited-returned times-visited-returned + 1]
      set previous-location "nest"
      decision-of-foraging-strategy ] ]                               ;; face decision which foraging strategy to chose: scouting or recruiting

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; HAPPY ANTS RETURN TO RESPECTIVE FS ;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ask successful-foragers-1
  [ ;pen-down
    pen-up
    set color blue                                                 ;; their colour is blue
    if if-food? = true                                            ;; if there is food
    [ set breed drinking-ants                                     ;; become drinking ants
      stop ]                                                      ;; do not "overrun" small food sources
    ifelse search-time < 0                                            ;; if food source 1 is not found within search time
    [ set nest-stay-time unloading-time                           ;; set nest stay time to the adjustable unloading time, default 60 ticks
      set previous-location "nest"
      set breed unsatisfied-foragers ]                            ;; become unsatisfied foragers
    [
      Learned-Head-to-FS-1  ] ]                                           ;; else: if there is time left, head for food source 1


;ask successful-foragers-2
; [ set color blue                                                 ;; their colour is blue
;    if if-food? = true                                            ;; if there is food
;    [ set breed drinking-ants                                     ;; become drinking ants
;      stop ]                                                      ;; do not "overrun" small food sources
;ifelse search-time < 0                                            ;; if food source 2 is not found within search time
;    [ set nest-stay-time unloading-time                           ;; set nest stay time to the adjustable unloading time, default 60 ticks
;      set breed unsatisfied-foragers ]                            ;; become unsatisfied foragers
;    [ Head-to-FS-2  ] ]                                           ;; else: if there is time left, head for food source 2

;;;;;;;;;;;;;;;;;;;;;;;;;
;;; TANDEM-INITIATION ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

ask Tandemstarters-1                                              ;; happy successful foragers 1 at the nest not knowing if recruits are present
  [ set color orange                                              ;; their colour is orange
    nest-stay                                                     ;; walk slowly
    set nest-stay-time nest-stay-time - 1                         ;; time they stay in the nest counts down
ifelse any? Tandemstarters-1 and any? recruits                    ;; if there are Tandemstarters 1 and recruits at the nest
   [ Tandemformation-1 ]                                          ;; start formation of a tandem to food source 1
  [ nest-stay ]                                                   ;; else: stay in the nest
if nest-stay-time < 0                                             ;; if nest stay time is over,
  [ set breed successful-foragers-1                               ;; become successful-foragers for food source 1 regardless of recruits presence
    reset-times  ] ]                                              ;; and reset internal times

;ask Tandemstarters-2                                              ;; happy successful foragers 2 at the nest not knowing if recruits are present
;  [ set color orange                                              ;; their colour is orange
;    nest-stay                                                     ;; walk slowly
;    set nest-stay-time nest-stay-time - 1                         ;; time they stay in the nest counts down
;ifelse any? Tandemstarters-2 and any? recruits                    ;; if there are Tandemstarters 2 and recruits at the nest
;   [ Tandemformation-2 ]                                          ;; start formation of a tandem to food source 2
;  [ nest-stay ]                                                   ;; else: stay in the nest
;if nest-stay-time < 0                                             ;; if nest stay time is over,
;  [ set breed successful-foragers-2                               ;; become successful-foragers for food source 2 regardless of recruits presence
;    reset-times  ] ]                                              ;; and reset internal times

;;;;;;;;;;;;;;;;;;;;;;
;;; TANDEM TO FS-1 ;;;
;;;;;;;;;;;;;;;;;;;;;;

ask Tandemleaders-1                                               ;; recruiters at  the nest, leading the tandem to food source 1
  [ pen-down
    set color cyan                                                                                                                                                                                                                                                                                              ;; their colour is cyan
    if if-food? = true                                            ;; if there is food
    [ ask my-links [die]
      set breed drinking-ants                                     ;; become drinking ants
      stop ]                                                      ;; do not "overrun" small food sources
ifelse search-time < 0                                            ;; if food source 1 is not found within search time
    [ set previous-location "nest"
      set breed unsatisfied-foragers ]                           ;; become unsatisfied foragers
    [ let temp-left random angle-perception
      let temp-right random angle-perception
      set tandem-left temp-left
      set tandem-right temp-right
      ask link-neighbors [ set tandem-left temp-left ]
      ask link-neighbors [ set tandem-right temp-right ]
      Tandem-Head-to-FS-1 tandem-left tandem-right distance-tr-pair walk-speed-tr-pair ] ]                                            ;; else: if there is time left, head for food source 1

ask Tandemfollowers-1                                             ;; former recruits at the nest
    [ pen-down
        set color cyan                                              ;; their colour is cyan
        set left-nest? 1
    set forager-timer forager-timer + 1                           ;; timer for time spend in the tandem advances
     tandem-breakup                                               ;; 5 ‰ chance per tick to loose food source direction
    if if-food? = true                                            ;; if there is food
        [ output-show forager-timer                                   ;; trigger the timer to display their time spend in the tandem
          ask my-links [die]
          set breed drinking-ants                                       ;; become drinking ants
      stop ]                                                      ;; do not "overrun" small food sources
ifelse search-time < 0                                            ;; if food source 1 is not found within search time
        [  set previous-location "nest"
          ask my-links [die]
          set breed unsatisfied-foragers ]                           ;; become unsatisfied foragers
          [ Tandem-Head-to-FS-1 tandem-left tandem-right distance-tr-pair walk-speed-tr-pair] ]                                      ;; else: if there is time left, head for food source 1

;;;;;;;;;;;;;;;;;;;;;;
;;; TANDEM TO FS-2 ;;;
;;;;;;;;;;;;;;;;;;;;;;

;ask Tandemleaders-2                                               ;; recruiters at  the nest, leading the tandem to food source 2
;  [ set color cyan                                                ;; their colour is cyan
;    if if-food? = true                                            ;; if there is food
;    [ set breed drinking-ants                                     ;; become drinking ants
;      stop ]                                                      ;; do not "overrun" small food sources
;ifelse search-time < 0                                            ;; if food source 2 is not found within search time
;    [  set breed unsatisfied-foragers ]                           ;; become unsatisfied foragers
;    [ tandem-FS-2  ] ]                                            ;; else: if there is time left, head for food source 2
;
;ask Tandemfollowers-2                                             ;; former recruits at the nest
;    [ set color cyan                                              ;; their colour is cyan
;    set forager-timer forager-timer + 1                           ;; timer for time spend in the tandem advances
;     tandem-breakup                                               ;; 5 ‰ chance per tick to loose food source direction
;    if if-food? = true                                            ;; if there is food
;    [ output-show forager-timer                                   ;; trigger the timer to display their time spend in the tandem
;     set breed drinking-ants                                      ;; become drinking ants
;      stop ]                                                      ;; do not "overrun" small food sources
;ifelse search-time < 0                                            ;; if food source 2 is not found within search time
;    [  set breed unsatisfied-foragers ]                           ;; become unsatisfied foragers
;    [ tandem-FS-2  ] ]                                            ;; else: if there is time left, head for food source 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; LOST TANDEM-RUNNERS ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

ask lost-TRs                                                      ;; tandem followers which have lost food source direction
  [ ask my-links [die]
    if patch-ahead 1 = nobody                                    ;; if they encounter a wall (non-patch)
    [ rt 180 ]                                                    ;; change direction by 180°
    if if-food? = true                                            ;; if there is food
    [ output-show forager-timer                                   ;; trigger the timer to display their time spend in the tandem
    set breed drinking-ants                                       ;; become drinking ants
      stop ]                                                      ;; do not "overrun" small food sources
     ifelse nest?                                                 ;; if there are at nest
  [   nest-stay                                                   ;; and walk slowly
     set nest-stay-time nest-stay-time - 1                        ;; time they stay in the nest counts down
ifelse nest-stay-time = 0                                         ;; if they are at the nest and nest stay time is over
[ unload                                                          ;; they give their forager energy (positive or negative value) to the nest (changing nest energy)
  decision-of-foraging-strategy ]                                 ;; face decision which foraging strategy to chose: scouting or recruiting
        [ nest-stay  ] ]                                          ;; else: if there is in the nest left stay at the nest
   [ wiggle angle-general                                                       ;; randomly change direction ("searching the food source")
      fd (velocity-outside)
      set total-foraging-distance total-foraging-distance +  (velocity-outside)                                   ;; move with half speed/tandem-speed
      if infection-status = 0 [set total-foraging-distance-ui total-foraging-distance-ui +  (velocity-outside )]
      if infection-status = 1 [set total-foraging-distance-i total-foraging-distance-i +  (velocity-outside )]
      set total-steps-taken total-steps-taken + 1
      if infection-status = 0 [set total-steps-taken-ui total-steps-taken-ui + 1]
      if infection-status = 1 [set total-steps-taken-i total-steps-taken-i + 1]
      set forager-energy forager-energy - metabolic-cost            ;; and with energy-costs
      set forager-energy-tracker forager-energy-tracker - metabolic-cost
      set forager-timer forager-timer + 1                           ;; timer for time spend searching a food source advances
      set search-time search-time - 1 ]                         ;; time they search for a food source counts down
 if (search-time) < 0                                             ;; if a food source is not found within search time
            [  decision-of-lost-TRS ] ]                           ;; decide on becoming a scout or return to nest

;;;;;;;;;;;;;;;;;;
;;; FS-ACTIONS ;;;
;;;;;;;;;;;;;;;;;;

;   FS-Disappearence                                               ;; food sources disappear when having no energy
;
;  if not any? patches with [ FS-number = 1 ]                      ;; if there is no food source with the number 1
;  [ ask patches                                                   ;; ask all patches
;   [ set FS-timer-1  FS-timer-1  - 1                              ;; to count-down the timer for food source 1
;     if FS-timer-1  = 0                                           ;; if the count-down is over
;      [  FS-Renewal-1                                             ;; let food source 1 reappear
;         set FS-timer-1  FS-timer ] ] ]                           ;; reset timer for food source 1

;  if not any? patches with [ FS-number = 2 ]                      ;; if there is no food source with the number 2
;  [ ask patches                                                   ;; ask all patches
;   [ set FS-timer-2  FS-timer-2  - 1                              ;; to count-down the timer for food source 2
;     if FS-timer-2  = 0                                           ;; if the count-down is over
;      [  FS-Renewal-2                                             ;; let food source 2 reappear
;         set FS-timer-2  FS-timer ] ] ]                           ;; reset timer for food source 2

  ;plot nest-energy                                                  ;; plot global variable nest energy

  set ind-ant-times-visited mean [times-visited] of turtles
  set total-num-food-visits sum [times-visited] of turtles
  set total-num-food-visits-returned sum [times-visited-returned] of turtles
  set total-num-food-visits-returned-ui sum [times-visited-returned] of turtles with [ infection-status = 0]
  set total-num-food-visits-returned-i sum [times-visited-returned] of turtles with [ infection-status = 1]
  set forager-energy-ui sum [forager-energy-tracker] of turtles with [ infection-status = 0]
  set forager-energy-i sum [forager-energy-tracker] of turtles with [ infection-status = 1]
  set ind-ant-times-disappointed mean [times-disappointed] of turtles
  set total-num-ants-visited sum [foraged?] of turtles
  ;set total-foraging-distance sum [distance-walked] of turtles
  set total-num-active-ants sum [left-nest?] of turtles
  ;set mean-route-efficiency mean (distance-walked-list)
  ;set benefit-per-ant (total-num-food-visits / 100)
  ;set cost-per-ant (total-foraging-distance
  ;set benefit-per-active-ant (total-num-food-visits / total-num-ants-visited)
  ;set cost-per-active-ant (total-foraging-distance / total-num-ants-visited)

tick                                                              ;; advance tick counter

;if ticks = 5400 = true [ export-output "Forager-Times.csv" ]      ;; after 5400 ticks write Timer-data of output-window to a file name "Forager-Times"

end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SET INFECTION IN COLONY ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to create-infected-ants [prevalence]
  ask turtles [set infection-status 0]
  let my-agentset n-of prevalence turtles
  ask my-agentset [set infection-status 1]
end


;;;;;;;;;;;;;;;;;;;;;;;;;
;;; MOVING PROCEDURES ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

to wiggle [angle-g]                                                        ;; general random orientation procedure: ant "chooses" random angle of orientation
rt random angle-g                                                      ;; random right angle
lt random angle-g                                                      ;; random left angle
end

to movement                                                       ;; general movement procedure
 ifelse nest?                                                     ;; if there are at nest
  [ ifelse breed = scouts or breed = successful-foragers-1        ;; and are scouts or successful-foragers
 ;   or breed = successful-foragers-2                              ;, to any of the food sources
    [ fd velocity-outside
   ]                                         ;; move without energy-costs but fast
    [ fd velocity-nest ] ]                                        ;; else there are other breeds: walk slowly inside the nest
[    fd velocity-outside
      set total-foraging-distance total-foraging-distance +  (velocity-outside )                                   ;; move with half speed/tandem-speed
      if infection-status = 0 [set total-foraging-distance-ui total-foraging-distance-ui +  (velocity-outside )]
      if infection-status = 1 [set total-foraging-distance-i total-foraging-distance-i +  (velocity-outside )]
      set total-steps-taken total-steps-taken + 1
      if infection-status = 0 [set total-steps-taken-ui total-steps-taken-ui + 1]
      if infection-status = 1 [set total-steps-taken-i total-steps-taken-i + 1]
                                                                   ;; else the agents are outside: move with fast speed
    set forager-energy forager-energy - metabolic-cost
    set forager-energy-tracker forager-energy-tracker - metabolic-cost ]            ;; and with energy-costs
end

to scouting                                                       ;; general procedure of scouts
  set left-nest? 1
ifelse patch-ahead 1 = nobody                                     ;; if they encounter a wall (non-patch)
    [ rt 180 ]                                                    ;; change direction by 180°
  [ Head-to-FS-1
;    wiggle angle-general                                                         ;; random change of orientation
;   movement                                                       ;; general movement
   set scouts-time scouts-time + 1                                ;; advance scouting time
   set forager-timer forager-timer + 1 ]                          ;; timer for time spend scouting advances
 end

to nest-stay                                                      ;; general procedure of ants staying in the nest
  set distance-walked 0
ifelse [nest?] of patch-ahead 1 = true                            ;; if they are at the nest
 [ wiggle angle-general                                                          ;; randomly change direction inside the nest
   movement ]                                                     ;; walk with slow velocity and without energy-costs
 [ rt 180                                                         ;; else: if not in the nest, turn around 180 degrees for not leaving the nest
   return-to-nest ]
end

to return-to-nest                                                 ;; return to the nest
;  movement                                                        ;; general movement
;  nest-scent-direction                                            ;; "smell" nest-scent
  ifelse patch-ahead 1 = nobody                                     ;; if they encounter a wall (non-patch)
    [ rt 180 ]                                                    ;; change direction by 180°
  [
  let distance-from-nest distancexy 0 0
  ifelse distance-from-nest < 30
    [if reorient-home mod reorient-tick = 0 [facexy 0 0]
      wiggle angle-perception
      movement
      ]

    [if reorient-home mod reorient-tick = 0 [facexy 0 0]
      wiggle angle-general
      movement
     ]
  ]
  set reorient-home reorient-home + 1
end

to nest-scent-direction                                           ;; foragers go where the strongest nest-scent is
;   let scent-ahead nest-scent-at-angle   0                        ;; local variable smell ahead of forager shall be nest-scent (at angle 0)
;   let scent-right nest-scent-at-angle  45                        ;; local variable smell right of forager shall be nest-scent (at angle 45)
;   let scent-left  nest-scent-at-angle -45                        ;; local variable smell left of forager shall be nest-scent (at angle -45)
;if (scent-right > scent-ahead) or (scent-left > scent-ahead)      ;; if the scent to the right is stronger or the scent to the left is stronger than the one straight forward
;[ ifelse scent-right > scent-left                                 ;; if the scent to the right is stronger than the one to the left
; [ rt 45 ]                                                        ;; the forager turns right by number degrees: If the number is negative, it turns left (follow only positive smell)
; [ lt 45 ] ]                                                      ;; else the forager turns left by number degrees: If the number is negative, it turns right (follow only positive smell)
end

to-report nest-scent-at-angle [angle]                             ;; reporter of the nest-scent-variable, feedback on how strong the nest scent is
 let p patch-right-and-ahead angle 1                              ;; p is a local variable and set to: The forager "looks" 1 degrees right of its current heading
 if p = nobody [ report 0 ]                                       ;; if the patch at this angle is non-existing (outside the arena), then it reports 0
 report [nest-scent] of p                                         ;; otherwise it reports the nest-scent of the "foragers look"
end

;;;;;;;;;;;;;;;;;;;;;;
;;; MOVEMENT TO FS ;;;
;;;;;;;;;;;;;;;;;;;;;;

to Head-to-FS-1                                                    ;; successful foragers move to food source 1
;FS-1-direction                                                     ;; "smell" FS-1
;movement                                                           ;; general movement
  set distance-walked distance-walked  + 1
  ifelse patch-ahead 1 = nobody                                     ;; if they encounter a wall (non-patch)
    [ rt 180 ]                                                    ;; change direction by 180°
  [
  let distance-from-nest distancexy -41 0
    ifelse distance-from-nest < distance-perception
    [ if reorient-time mod reorient-tick = 0 [facexy -41 0]
      wiggle angle-perception
        movement
      ]
  [   wiggle angle-general
      movement
     ]


  ]
  set search-time search-time - 1                                    ;; time they search for food source 1 counts down
  set reorient-time reorient-time + 1
end

to Learned-Head-to-FS-1                                                    ;; learned ants going back to food
  set distance-walked distance-walked + 1
  ifelse patch-ahead 1 = nobody                                     ;; if they encounter a wall (non-patch)
    [ rt 180 ]                                                    ;; change direction by 180°
  [
  let distance-from-nest distancexy -41 0
  if reorient-time mod reorient-tick = 0 [facexy -41 0]
  ifelse distance-from-nest < distance-perception
    [
      wiggle angle-perception
        movement
      ]
  [   wiggle angle-general
      movement
     ]
  ]
  set search-time search-time - 1                                    ;; time they search for food source 1 counts down
  set reorient-time reorient-time + 1
end

to Tandem-Head-to-FS-1 [ angle-left angle-right distance-l walk-speed-l ]                                                    ;; learned ants going back to food

  set distance-walked distance-walked + 1
  ifelse patch-ahead 1 = nobody                                     ;; if they encounter a wall (non-patch)
    [ rt 180 ]                                                    ;; change direction by 180°
  [
  let distance-from-nest distancexy -41 0
  if reorient-time mod reorient-tick = 0 [facexy -41 0]
    ifelse distance-from-nest < distance-l
    [
      rt angle-right
      lt angle-left
        fd (walk-speed-l)
      set total-foraging-distance total-foraging-distance +  (walk-speed-l )                                   ;; move with half speed/tandem-speed
      if infection-status = 0 [set total-foraging-distance-ui total-foraging-distance-ui +  (walk-speed-l)]
      if infection-status = 1 [set total-foraging-distance-i total-foraging-distance-i +  (walk-speed-l)]
      set total-steps-taken total-steps-taken + 1
      if infection-status = 0 [set total-steps-taken-ui total-steps-taken-ui + 1]
      if infection-status = 1 [set total-steps-taken-i total-steps-taken-i + 1]
      ]
    [ rt angle-right
      lt angle-left
      fd (walk-speed-l)
      set total-foraging-distance total-foraging-distance +  (walk-speed-l )                                   ;; move with half speed/tandem-speed
      if infection-status = 0 [set total-foraging-distance-ui total-foraging-distance-ui +  (walk-speed-l)]
      if infection-status = 1 [set total-foraging-distance-i total-foraging-distance-i +  (walk-speed-l)]
      set total-steps-taken total-steps-taken + 1
      if infection-status = 0 [set total-steps-taken-ui total-steps-taken-ui + 1]
      if infection-status = 1 [set total-steps-taken-i total-steps-taken-i + 1]
     ]
  ]
  set search-time search-time - 1                                    ;; time they search for food source 1 counts down
  set reorient-time reorient-time + 1
  if not nest? [
    set forager-energy forager-energy - metabolic-cost
    set forager-energy-tracker forager-energy-tracker - metabolic-cost ]   ;; if there are outside nest, energy costs are applied

end

;to Head-to-FS-2                                                    ;; successful foragers move to food source 2
;FS-2-direction                                                     ;; "smell" FS-2
;movement                                                           ;; general movement
;set search-time search-time - 1                                    ;; time they search for food source 2 counts down
;end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; MOVEMENT OF TANDEM to FS ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;to tandem-FS-1                                                     ;; Tandem-1 heads to FS-1 together
;ifelse nest?                                                       ;; if there are at nest
;  [ FS-1-direction                                                 ;; "smell" FS-1
;    fd (velocity-outside / 2 )                                     ;; move with half speed ("tandem-speed") to FS-1
;    set search-time search-time - 1 ]                              ;; time they search for FS-1 counts down
; [  FS-1-direction                                                 ;; "smell" FS-1
;    fd (velocity-outside / 2 )                                     ;; move with half speed ("tandem-speed") to FS-1
;    set forager-energy forager-energy - metabolic-cost             ;; and with energy-costs
;    set search-time search-time - 1 ]                              ;; time they search for FS-1 counts down
;end

;to tandem-FS-2                                                     ;; Tandem-2 heads to FS-2 together
;ifelse nest?                                                       ;; if there are at nest
;  [ FS-2-direction                                                 ;; "smell" FS-2
;    fd (velocity-outside / 2 )                                     ;; move with half speed ("tandem-speed") to FS-2
;    set search-time search-time - 1 ]                              ;; time they search for FS-1 counts down
; [  FS-2-direction                                                 ;; "smell" FS-2
;    fd (velocity-outside / 2 )                                     ;; move with half speed ("tandem-speed") to FS-2
;    set forager-energy forager-energy - metabolic-cost             ;; and with energy-costs
;    set search-time search-time - 1 ]                              ;; time they search for FS-2 counts down
;end

to FS-1-direction                                                  ;; foragers go where the strongest FS-scent-1 is
 let scent-ahead food-scent-at-angle-1   0                         ;; local variable smell ahead of forager shall be food-scent-1 (at angle 0)
  let scent-right food-scent-at-angle-1  45                        ;; local variable smell ahead of forager shall be food-scent-1 (at angle 45)
  let scent-left  food-scent-at-angle-1 -45                        ;; local variable smell ahead of forager shall be food-scent-1 (at angle -45)
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)     ;; if the scent to the right is stronger or the scent to the left is stronger than the one straight forward
 [ ifelse scent-right > scent-left                                 ;; if the scent to the right is stronger than the one to the left
 [ rt 45 ]                                                         ;; the forager turns right by number degrees: If the number is negative, it turns left (follow only positive smell)
 [ lt 45 ] ]                                                       ;; else the forager turns left by number degrees: If the number is negative, it turns right (follow only positive smell)
end

to-report food-scent-at-angle-1 [angle]                            ;; reporter of the food-scent-1-variable, feedback on how strong the food scent of FS-1 is
let p patch-right-and-ahead angle 1                                ;; p is a local variable and set to: The forager "looks" 1 degrees right of its current heading
if p = nobody [ report 0 ]                                         ;; if the patch at this angle is non-existing (outside the arena), then it reports 0
;report [ FS-scent-1 ] of p                                         ;; otherwise it reports the FS-scent-1 of the "foragers look"
end

;to FS-2-direction                                                  ;; foragers go where the strongest FS-scent-2 is
; let scent-ahead food-scent-at-angle-2   0                         ;; local variable smell ahead of forager shall be food-scent-2 (at angle 0)
;  let scent-right food-scent-at-angle-2  45                        ;; local variable smell ahead of forager shall be food-scent-2 (at angle 45)
;  let scent-left  food-scent-at-angle-2 -45                        ;; local variable smell ahead of forager shall be food-scent-2 (at angle -45)
;  if (scent-right > scent-ahead) or (scent-left > scent-ahead)     ;; if the scent to the right is stronger or the scent to the left is stronger than the one straight forward
; [ ifelse scent-right > scent-left                                 ;; if the scent to the right is stronger than the one to the left
; [ rt 45 ]                                                         ;; the forager turns right by number degrees: If the number is negative, it turns left (follow only positive smell)
; [ lt 45 ] ]                                                       ;; else the forager turns left by number degrees: If the number is negative, it turns right (follow only positive smell)
;end
;
;to-report food-scent-at-angle-2 [angle]                            ;; reporter of the food-scent-2-variable, feedback on how strong the food scent of FS-2 is
;let p patch-right-and-ahead angle 1                                ;; p is a local variable and set to: The forager "looks" 1 degrees right of its current heading
;if p = nobody [ report 0 ]                                         ;; if the patch at this angle is non-existing (outside the arena), then it reports 0
;report [ FS-scent-2 ] of p                                         ;; otherwise it reports the FS-scent-2 of the "foragers look"
;end
;
to tandem-breakup
  let breakup-prob random-float 1.00000                            ;; probability is random from 0.00000-0.99999
if breakup-prob < TR-breakup-probability                           ;; default at 0.00005, meanig a 5/1000 chance of becoming lost (0.00000-0.00049 lost-TR, 0.00005-1.00000 remain Tandem-Follower(-1 or -2).
  [ set color sky                                                  ;; tandem follower suffering a tandem breakup are sky in color
  set forager-timer forager-timer - 1                              ;; timer for time spend searching a food source is reset by 1 for transformation
  set search-time search-time + 1                                  ;; time they search for a food source is reset by 1 for transformation
  set forager-energy forager-energy + metabolic-cost               ;; energy-costs is reset by one metabolic-cost unit for transformation
    set forager-energy-tracker forager-energy-tracker + metabolic-cost
    set num-breakup num-breakup + 1
    ask my-links [die]
    set breed lost-TRs ]                                           ;; and lost
 end

;;;;;;;;;;;;;;;;;;;;;;;;;
;;; OTHER ACTIONS ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

to feed                                                            ;; general feeding procedure performed by drinking ants
  if FS-number = 1                                                   ;; if the food source number is 1
      [ set FS-energy FS-energy - (reward-FS-1 / 120)                 ;; energy of the food source 1 is diminished by the reward of food source 1 divided by the feeding time
        set forager-energy forager-energy + (reward-FS-1 / 120)       ;; get the reward of food source 1 divided by the feeding time (incomplete feeding possible)
        set forager-energy-tracker forager-energy-tracker + (reward-FS-1 / 120)
        set feeding-time feeding-time - 1                              ;; the feeding-time counts down
if (feeding-time = 0)                                              ;; if the feeding time is over
        [ set distance-walked-list lput ( 40 / (distance-walked * 0.8)) distance-walked-list
          set times-visited times-visited + 1
          ;set previous-location "food"
          decision-of-happiness-1 ] ]                                  ;; decide wether to be happy or unsatisfied with food source 1

;if FS-number = 2                                                   ;; if the food source number is 2
;   [ set FS-energy FS-energy - (reward-FS-2 / 120)                 ;; energy of the food source 2 is diminished by the reward of food source 2 divided by the feeding time
;     set forager-energy forager-energy + (reward-FS-2 / 120)       ;; get the reward of food source 1 divided by the feeding time (incomplete feeding possible)
;    set feeding-time feeding-time - 1                              ;; the feeding-time counts down
;if (feeding-time = 0)                                              ;; if the feeding time is over
;    [ decision-of-happiness-2 ] ]                                  ;; decide wether to be happy or unsatisfied with food source 2
end

to unload                                                          ;; procedure at the nest: transfer forager energy to nest
  ask my-links [die]
  set nest-energy nest-energy + forager-energy                     ;; turnover energy (positive and negative values possible)
  set forager-energy 0                                             ;; reset forager-energy to 0 (all energy has been transferred to nest)
end

to reset-times                                                     ;; reset internal timers of the agents
  set feeding-time 120                                             ;; feeding time is default 120 ticks
  set scouts-time 0                                                ;; scouting time is default 0
  set nest-stay-time unloading-time                                ;; nest stay time is the adjustable unloading time, default 60 ticks
  set search-time FS-searching-time                                ;; search time for a food source is default 180 ticks
  set forager-timer 0                                              ;; forager time is reset to 0
end



;;;;;;;;;;;;;;;;;;;;;;;;
;;; TANDEM-FORMATION ;;;
;;;;;;;;;;;;;;;;;;;;;;;;

to Tandemformation-1                                               ;; tandem to food source 1 forms
  let Follower one-of recruits-on patches with [ nest? = true ]                                ;; Tandemfollower-1 shall be a random recruit
  let prob-1 random 10000
  let prob-2 random 10000
if Follower != nobody  and ( prob-2 / 10000 < prob-of-leading ) and ( prob-1 / 10000 < prob-of-following )                                             ;; got a recruit?
[ ask Tandemstarters-1-here                                        ;; if a Tandemstarter-1 encounters a recruit on the same patch
   [ set number-tr number-tr + 1
      ;set tr-walk-speed first [velocity-outside] of Tandemstarters-1-here
      set breed Tandemleaders-1                                     ;; and she becomes a Tandemleader-1
      set distance-tr-pair [distance-perception] of self
      set walk-speed-tr-pair [velocity-outside] of self
      set leader-id who
      let temp-id leader-id
      ;set tr-distance-perception [distance-perception] of Tandemstarters-1-here
      create-link-with Follower
      ask link-neighbors [set leader-id temp-id]
      reset-times ]                                                ;; reset internal timers
ask Follower                                                       ;; the recruit becomes a Follower
    [ set distance-tr-pair [distance-perception] of turtle leader-id
      set walk-speed-tr-pair [velocity-outside] of turtle leader-id
      output-show forager-timer                                        ;; and triggers the timer to display their time spend waiting to be recruited
      set breed Tandemfollowers-1                                      ;; become Tandem-Followers to FS-1
                                                                       ;set tr-distance-perception [distance-perception] of Tandemstarters-1-here
      reset-times ]

  ]                                                  ;; reset internal timers
end

;to Tandemformation-2                                               ;; tandem to food source 2 forms
;  let Follower one-of recruits-here                                ;; Tandemfollower-2 shall be a random recruit
;if Follower != nobody                                              ;; got a recruit?
;[ ask Tandemstarters-2-here                                        ;; if a Tandemstarter-2 encounters a recruit on the same patch
;   [ set breed Tandemleaders-2                                     ;; and he becomes a Tandemleader-2
;      reset-times ]                                                ;; reset internal timers
;ask Follower                                                       ;; the recruit becomes a Follower
;[ output-show forager-timer                                        ;; and triggers the timer to display their time spend waiting to be recruited
;  set breed Tandemfollowers-2                                      ;; become Tandem-Followers to FS-2
;  reset-times ] ]                                                  ;; reset internal timers
;end

;;;;;;;;;;;;;;;;;
;;; DECISIONS ;;;
;;;;;;;;;;;;;;;;;

to decision-of-foraging                                            ;; decision wether to go on foraging
  ifelse abs pxcor >= 35 or abs pycor >= 35                        ;; if to far out (half arena size perimeter)
  [ set breed returning-scouts ]                                   ;; return to nest
    [ set scouts-time 300 ]                                        ;; otherwise get an additionally 300 ticks scouting time
end

to decision-of-happiness-1                                         ;; decision wether to be happy with FS-1 or not                                                    ;; reset internal timers of agents
  ifelse  FS-quality  > 0                                          ;; if the quality of food source 1 is high
  [ set happiness 100 ]                                            ;; be 100% satisfied with it and become happy-sucessful-foragers-1
  [ set happiness random 100 ]                                     ;; else the FS-quality is low; the foragers are randomly happy with it
ifelse happiness >= happiness-threshold                            ;; if their happiness is same or higher than the adjustable happiness-threshold (default at 90 %, meaning only 10 % of ants will be happy with a low quality FS-1).
  [ set previous-location "food"
    set breed happy-successful-foragers-1  ]                        ;; be happy with FS-1 and become happy-successful-foragers-1 (90-99: happy)
  [ set previous-location "food"
    set breed unsatisfied-foragers ]                               ;; be unhappy with FS-1 and become unsatisfied-foragers (0-89: unhappy)
end

;to decision-of-happiness-2                                         ;; decision wether to be happy with FS-2 or not
;  reset-times                                                      ;; reset internal timers
;  ifelse  FS-quality  > 0                                          ;; if the quality of food source 2 is high
;  [ set happiness 100 ]                                            ;; be 100% satisfied with it and become happy-sucessful-foragers-2
;  [ set happiness random 100 ]                                     ;; else the FS-quality is low; the foragers are randomly happy with it
;ifelse happiness >= happiness-threshold                            ;; if their happiness is same or higher than the adjustable happiness-threshold (default at 90 %, meaning only 10 % of ants will be happy with a low quality FS-2).
;  [ set breed happy-successful-foragers-2 ]                        ;; be happy with FS-2 and become happy-successful-foragers-2 (90-99: happy)
;  [ set breed unsatisfied-foragers ]                               ;; be unhappy with FS-2 and become unsatisfied-foragers (0-89: unhappy)
;end

to decision-of-recruitment-1                                       ;; decision if recruitment to FS-1 happens
  reset-times                                                     ;; reset internal timers
  let leading-prob random 10000                                       ;; probability to recruit is random from 0-99
ifelse (leading-prob / 10000 < 1)                     ;; if the recruitment-probability-1 (default 50) is higher than random value
  [ set nest-stay-time 1                                         ;; their nest-stay-time is set to 120 and
    set breed Tandemstarters-1
  ]                                   ;; recruitment will iniate.
  [ set breed successful-foragers-1 ]                              ;; else: head to FS-1 alone with private information
end

;to decision-of-recruitment-2                                       ;; decision if recruitment to FS-2 happens
;  reset-times                                                      ;; reset internal timers
;  let recruitprob random 100                                       ;; probability to recruit is random from 0-99
;ifelse recruitment-probability-2 > recruitprob                     ;; if the recruitment-probability-2 (default 50) is higher than random value
;  [ set nest-stay-time 120                                         ;; their nest-stay-time is set to 120 and
;    set breed Tandemstarters-2 ]                                   ;; recruitment will iniate.
;  [ set breed successful-foragers-2 ]                              ;; head to FS-2 alone with private information
;end

to decision-of-foraging-strategy                                   ;; decision of unsatisfied foragers  whether to become scouts or recruits when their time in nest is over
  reset-times                                                      ;; reset internal timers
  let strategyprob random 100                                      ;; probability to become a scout or recruit is random from 0-99
ifelse strategyprob < 50                                           ;; chance of becoming a scout or recruit is equal! (0-49: scout, 50-99 recruit)
  [
    set breed scouts                                               ;; become scouts
    set color red
  ]                                                ;; and are red
  [ set breed recruits                                             ;; become recruits
    set color grey ]                                               ;; and are grey
end

to decision-of-lost-TRS                                            ;; decision of lost-TRs wether to become a scout or return to the nest when they failed to find a FS in the search time
  let strategyprob random 100                                      ;; probability to become a scout or return to nest is random from 0-99.
ifelse strategyprob < 50                                           ;; chance of scouting or return to nest is equal (0-49: scouts, 50-99 return to nest)
  [ set breed scouts                                               ;; become scouts
    set color red                                                  ;; and are red
      reset-times ]                                                ;; reset internal timers
  [ set breed unsatisfied-foragers ]                               ;; else: become an unsatisfied forager and return to nest
end

;;;;;;;;;;;;;;;;;;FS-Disappearence
;;; FS-ACTIONS ;;;
;;;;;;;;;;;;;;;;;;

to FS-Disappearence                                                ;; food sources vanishes when their energy is depleted
 ask patches with [ FS-number = 1 ]                                ;; all patches with food source number 1
 [ if FS-energy < 0.00001                                          ;; if the food source energy is too low to feed on it
 [ set if-food? false                                              ;; become a "normal" patch again
   set  FS-quality  0                                              ;; have 0 quality
   set pcolor black                                                ;; black color
   set FS-number 0 ] ]                                             ;; and no food source number
; ask patches with [ FS-number = 2 ]                                ;; all patches with food source number 2
; [ if FS-energy < 0.00001                                          ;; if the food source energy is too low to feed on it
; [ set if-food? false                                              ;; become a "normal" patch again
;   set  FS-quality  0                                              ;; have 0 quality
;   set pcolor black                                                ;; black color
;   set FS-number 0 ] ]                                             ;; and no food source number
end

to FS-Renewal-1                                                    ;; food source 1 can reappear
    ask patch -31 0                                                ;; at the same location as the former food source 1
 [ set pcolor white                                                ;; the food source center shall be white of color
   if (distancexy -31 0 ) < Food-size-one                          ;; the new food source the same size as the old food source 1
 [ set FS-number 1                                                 ;; give it the number 1
   set if-food? true                                               ;; let it have food
  ; set FS-scent-1 200 - distancexy -31 0                           ;; and a food scent
ifelse reward-FS-1 >= 0.75                                         ;; if the depleted FS had high quality food,
 [ set  FS-quality  1                                              ;; the new FS also has a high quality
   set FS-energy food-energy-high ]                                ;; and high energy
 [ set  FS-quality  0                                              ;; else it has a low quality
   set FS-energy food-energy-low] ] ]                              ;; and a low energy
end

;to FS-Renewal-2                                                    ;; food source 1 can reappear
;    ask patch 31 0                                                 ;; at the same location as the former food source 1
; [ set pcolor white                                                ;; the food source center shall be white of color
;   if (distancexy 31 0 ) < Food-size-two                           ;; the new food source the same size as the old food source 1
; [ set FS-number 2                                                 ;; give it the number 2
;   set if-food? true                                               ;; let it have food
;   set FS-scent-2 200 - distancexy 31 0                            ;; and a food scent
;ifelse reward-FS-2 >= 0.75                                         ;; if the depleted FS had high quality food,
; [ set  FS-quality  1                                              ;; the new FS also has a high quality
;   set FS-energy food-energy-high ]                                ;; and high energy
; [ set  FS-quality  0                                              ;; else it has a low quality
;   set FS-energy food-energy-low] ] ]                              ;; and a low energy
;end
@#$#@#$#@
GRAPHICS-WINDOW
405
10
1155
761
-1
-1
5.26241135
1
10
1
1
1
0
0
0
1
-70
70
-70
70
1
1
1
ticks
30.0

BUTTON
10
20
90
53
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
318
24
393
57
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
10
109
183
142
Food-size-one
Food-size-one
1
10
1.0
1
1
NIL
HORIZONTAL

SLIDER
10
146
183
179
nest-size
nest-size
1
10
2.0
1
1
NIL
HORIZONTAL

SLIDER
200
70
377
103
number-of-recruits
number-of-recruits
0.0
100.0
0.0
1.0
1
NIL
HORIZONTAL

SLIDER
9
71
182
104
number-of-scouts
number-of-scouts
0.0
100.0
25.0
1.0
1
NIL
HORIZONTAL

SLIDER
10
336
183
369
velocity-nest
velocity-nest
0.01
1
0.1
0.01
1
NIL
HORIZONTAL

PLOT
7
461
399
737
Nestenergy
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot nest-energy"
"pen-1" 1.0 0 -7500403 true "" "plot total-num-food-visits "

SLIDER
200
108
377
141
Food-size-two
Food-size-two
1
10
1.0
1
1
NIL
HORIZONTAL

SLIDER
10
296
183
329
unloading-time
unloading-time
1
120
58.0
1
1
NIL
HORIZONTAL

SLIDER
10
185
184
218
reward-FS-1
reward-FS-1
0.075
0.75
0.75
0.675
1
NIL
HORIZONTAL

SLIDER
201
185
377
218
reward-FS-2
reward-FS-2
0.075
0.75
0.075
0.675
1
NIL
HORIZONTAL

SLIDER
10
222
184
255
recruitment-probability-1
recruitment-probability-1
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
201
223
378
256
recruitment-probability-2
recruitment-probability-2
1
100
51.0
1
1
NIL
HORIZONTAL

SLIDER
200
147
377
180
happiness-threshold
happiness-threshold
1
100
90.0
1
1
NIL
HORIZONTAL

SLIDER
10
374
184
407
metabolic-cost
metabolic-cost
0
10
2.44699E-7
0.000000000001
1
NIL
HORIZONTAL

SLIDER
193
373
370
406
food-energy-high
food-energy-high
7.5
7500
7496.25
0.75
1
NIL
HORIZONTAL

SLIDER
200
264
377
297
FS-timer
FS-timer
1
900
625.0
1
1
NIL
HORIZONTAL

SLIDER
10
411
182
444
FS-searching-time
FS-searching-time
60
600
120.0
1
1
NIL
HORIZONTAL

SLIDER
9
259
184
292
TR-breakup-probability
TR-breakup-probability
0.00001
1.00000
1.7E-4
0.00001
1
NIL
HORIZONTAL

SLIDER
193
411
370
444
food-energy-low
food-energy-low
0.75
750
749.775
0.075
1
NIL
HORIZONTAL

SLIDER
1178
427
1350
460
reorient-tick
reorient-tick
1
20
5.0
2
1
NIL
HORIZONTAL

INPUTBOX
99
10
190
70
colony-size
100.0
1
0
Number

SLIDER
1176
473
1353
506
disease-prevalence
disease-prevalence
0
1
0.6
.05
1
NIL
HORIZONTAL

SWITCH
1197
378
1338
411
cost-breakup
cost-breakup
1
1
-1000

TEXTBOX
1189
668
1339
710
0.1 - low\n0.5 - medium\n0.9 - high
11
0.0
1

TEXTBOX
1189
248
1339
266
Social parameters
11
0.0
1

TEXTBOX
1206
18
1356
36
Individual parameter\n
11
0.0
1

SLIDER
1189
38
1361
71
cost-leaving
cost-leaving
0
1
0.0
1
1
NIL
HORIZONTAL

SLIDER
1186
81
1361
114
cost-perception-distance
cost-perception-distance
0
1
0.0
1
1
NIL
HORIZONTAL

SLIDER
1188
121
1363
154
cost-perception-angle
cost-perception-angle
0
1
0.0
1
1
NIL
HORIZONTAL

SLIDER
1186
162
1358
195
cost-walk-speed
cost-walk-speed
0
1
1.0
1
1
NIL
HORIZONTAL

SLIDER
1189
208
1360
241
cost-disappointment
cost-disappointment
0
1
0.0
1
1
NIL
HORIZONTAL

SLIDER
1190
269
1362
302
cost-leading
cost-leading
0
1
0.0
1
1
NIL
HORIZONTAL

SLIDER
1196
329
1368
362
cost-following
cost-following
0
1
0.0
1
1
NIL
HORIZONTAL

SLIDER
1172
519
1349
552
cost-of-infection
cost-of-infection
0
1
0.67
0.01
1
NIL
HORIZONTAL

INPUTBOX
390
114
539
174
disappointment-SA
600.0
1
0
Number

INPUTBOX
387
185
616
245
leading-SA
1.0
1
0
Number

INPUTBOX
385
265
534
325
walk-SA
0.8
1
0
Number

INPUTBOX
391
343
540
403
angle-SA
30.0
1
0
Number

INPUTBOX
296
458
525
518
distance-SA
20.0
1
0
Number

BUTTON
209
25
309
58
go 90 min
repeat 5400 [ go ]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1022
23
1150
68
NIL
forager-energy-ui
17
1
11

MONITOR
1023
76
1194
121
NIL
forager-energy-i
17
1
11

@#$#@#$#@
## Foraging Ants



This model was created with the Netlogo software 6.1.0 on the basis of an ant model created by Uri Wilensky in 1997.

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

* Wilensky, U. (1997).  NetLogo Ants model.  http://ccl.northwestern.edu/netlogo/models/Ants.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="single_ant_test_model" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>ind-ant-times-disappointed</metric>
    <metric>total-num-ants-visited</metric>
    <metric>number-tr</metric>
    <metric>num-breakup</metric>
    <metric>mean (distance-walked-list)</metric>
    <metric>total-foraging-distance</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-recruits">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-general">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-perception">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-perception">
      <value value="20"/>
    </enumeratedValueSet>
    <steppedValueSet variable="prob-of-leading" first="0.1" step="0.1" last="1"/>
    <steppedValueSet variable="prob-of-following" first="0.1" step="0.1" last="1"/>
  </experiment>
  <experiment name="two_ant_test_model" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>ind-ant-times-disappointed</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-ants-visited</metric>
    <metric>number-tr</metric>
    <metric>num-breakup</metric>
    <metric>total-foraging-distance</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-recruits">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-general">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-perception">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-perception">
      <value value="20"/>
    </enumeratedValueSet>
    <steppedValueSet variable="prob-of-leading" first="0.1" step="0.1" last="1"/>
    <steppedValueSet variable="prob-of-following" first="0.1" step="0.1" last="1"/>
  </experiment>
  <experiment name="nest_size_sensitivity" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>ind-ant-times-disappointed</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-ants-visited</metric>
    <metric>number-tr</metric>
    <metric>num-breakup</metric>
    <metric>total-foraging-distance</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-recruits">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-general">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-perception">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-perception">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-of-leading">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-of-following">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nest-size">
      <value value="1"/>
      <value value="2"/>
      <value value="4"/>
      <value value="8"/>
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="colony_size_effects" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>ind-ant-times-disappointed</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-ants-visited</metric>
    <metric>number-tr</metric>
    <metric>num-breakup</metric>
    <metric>total-foraging-distance</metric>
    <metric>benefit-per-ant</metric>
    <metric>cost-per-ant</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="4"/>
      <value value="5"/>
      <value value="6"/>
      <value value="7"/>
      <value value="8"/>
      <value value="9"/>
      <value value="10"/>
      <value value="11"/>
      <value value="12"/>
      <value value="13"/>
      <value value="14"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-general">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-perception">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-perception">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-of-leading">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-of-following">
      <value value="0.25"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="colony_size_prob_recruitment_effects" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>ind-ant-times-disappointed</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-ants-visited</metric>
    <metric>number-tr</metric>
    <metric>num-breakup</metric>
    <metric>total-foraging-distance</metric>
    <metric>benefit-per-ant</metric>
    <metric>cost-per-ant</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="4"/>
      <value value="5"/>
      <value value="6"/>
      <value value="7"/>
      <value value="8"/>
      <value value="9"/>
      <value value="10"/>
      <value value="11"/>
      <value value="12"/>
      <value value="13"/>
      <value value="14"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-general">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-perception">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-perception">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-of-leading">
      <value value="0.25"/>
      <value value="0.5"/>
      <value value="0.75"/>
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="ratio_effects" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>ind-ant-times-disappointed</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-ants-visited</metric>
    <metric>number-tr</metric>
    <metric>num-breakup</metric>
    <metric>total-foraging-distance</metric>
    <metric>benefit-per-ant</metric>
    <metric>cost-per-ant</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="0"/>
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
      <value value="60"/>
      <value value="70"/>
      <value value="80"/>
      <value value="90"/>
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-general">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-perception">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-perception">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-of-leading">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-of-following">
      <value value="0.25"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="comparing_conditions" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-steps-taken</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-perception-distance">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-perception-angle">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-walk-speed">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leading">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-disappointment">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infection-level">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="disease-cost-following" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-steps-taken</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-perception-distance">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-perception-angle">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-walk-speed">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leading">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-following">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-disappointment">
      <value value="0"/>
    </enumeratedValueSet>
    <steppedValueSet variable="infection-level" first="0" step="0.2" last="1"/>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
      <value value="0.75"/>
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="sa-dis-walk-speed-finegrain" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-steps-taken</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-perception-distance">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-perception-angle">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-walk-speed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leading">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-disappointment">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disappointment-SA">
      <value value="100"/>
      <value value="300"/>
      <value value="600"/>
      <value value="900"/>
      <value value="1200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.05"/>
      <value value="0.1"/>
      <value value="0.15"/>
      <value value="0.2"/>
      <value value="0.25"/>
      <value value="0.3"/>
      <value value="0.35"/>
      <value value="0.4"/>
      <value value="0.45"/>
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="disease-covary" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-steps-taken</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-perception-distance">
      <value value="0"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-perception-angle">
      <value value="0"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-walk-speed">
      <value value="0"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leading">
      <value value="0"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-disappointment">
      <value value="0"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="regsim" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-steps-taken</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.2"/>
      <value value="0.4"/>
      <value value="0.6"/>
      <value value="0.8"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.5"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="distanceSA" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-steps-taken</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="walk-SA">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-SA">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="leading-SA">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disappointment-SA">
      <value value="600"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-SA">
      <value value="14"/>
      <value value="16"/>
      <value value="20"/>
      <value value="24"/>
      <value value="26"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.5"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="angleSA" repetitions="50" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-steps-taken</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="walk-SA">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="leading-SA">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disappointment-SA">
      <value value="600"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-SA">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-SA">
      <value value="21"/>
      <value value="24"/>
      <value value="30"/>
      <value value="36"/>
      <value value="39"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.5"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="walkSA" repetitions="50" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-steps-taken</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="leading-SA">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disappointment-SA">
      <value value="600"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-SA">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-SA">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="walk-SA">
      <value value="0.56"/>
      <value value="0.64"/>
      <value value="0.8"/>
      <value value="0.96"/>
      <value value="1.04"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.5"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="dissSA" repetitions="50" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-steps-taken</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="leading-SA">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disappointment-SA">
      <value value="420"/>
      <value value="480"/>
      <value value="600"/>
      <value value="720"/>
      <value value="780"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-SA">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-SA">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="walk-SA">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.5"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="leadingSA" repetitions="50" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-steps-taken</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="leading-SA">
      <value value="0.175"/>
      <value value="0.2"/>
      <value value="0.25"/>
      <value value="0.3"/>
      <value value="0.325"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disappointment-SA">
      <value value="600"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-SA">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-SA">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="walk-SA">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.5"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="walk_SA_troubleshoot" repetitions="200" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-steps-taken</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-perception-distance">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-perception-angle">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-walk-speed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leading">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-disappointment">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="leading-SA">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disappointment-SA">
      <value value="600"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-SA">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-SA">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="walk-SA">
      <value value="0.4"/>
      <value value="0.64"/>
      <value value="0.8"/>
      <value value="0.96"/>
      <value value="1.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.2"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.8"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="varying-prevalence" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-steps-taken</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="testing_new_measures" repetitions="10" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>count turtles with [infection-status = 0]</metric>
    <metric>count turtles with [infection-status = 1]</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-food-visits-returned-ui</metric>
    <metric>total-num-food-visits-returned-i</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-foraging-distance-ui</metric>
    <metric>total-foraging-distance-i</metric>
    <metric>total-steps-taken</metric>
    <metric>total-steps-taken-ui</metric>
    <metric>total-steps-taken-i</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-perception-distance">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-perception-angle">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-walk-speed">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leading">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-disappointment">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.8"/>
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="split_data" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-food-visits-returned-ui</metric>
    <metric>total-num-food-visits-returned-i</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-foraging-distance-ui</metric>
    <metric>total-foraging-distance-i</metric>
    <metric>total-steps-taken</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="sa-long-simulation" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="21600"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-food-visits-returned-ui</metric>
    <metric>total-num-food-visits-returned-i</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-foraging-distance-ui</metric>
    <metric>total-foraging-distance-i</metric>
    <metric>forager-energy-ui</metric>
    <metric>forager-energy-i</metric>
    <metric>total-steps-taken</metric>
    <metric>number-tr</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="0.9"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="all-infected" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-food-visits-returned-ui</metric>
    <metric>total-num-food-visits-returned-i</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-foraging-distance-ui</metric>
    <metric>total-foraging-distance-i</metric>
    <metric>forager-energy-ui</metric>
    <metric>forager-energy-i</metric>
    <metric>total-steps-taken</metric>
    <metric>number-tr</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="1"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="main-simulation-results-default" repetitions="1000" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-food-visits-returned-ui</metric>
    <metric>total-num-food-visits-returned-i</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-foraging-distance-ui</metric>
    <metric>total-foraging-distance-i</metric>
    <metric>forager-energy-ui</metric>
    <metric>forager-energy-i</metric>
    <metric>total-steps-taken</metric>
    <metric>number-tr</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.5"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="main-simulation-results-covary-social-costs-2" repetitions="500" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-food-visits-returned-ui</metric>
    <metric>total-num-food-visits-returned-i</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-foraging-distance-ui</metric>
    <metric>total-foraging-distance-i</metric>
    <metric>forager-energy-ui</metric>
    <metric>forager-energy-i</metric>
    <metric>total-steps-taken</metric>
    <metric>number-tr</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.5"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="main-simulation-results" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-food-visits-returned-ui</metric>
    <metric>total-num-food-visits-returned-i</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-foraging-distance-ui</metric>
    <metric>total-foraging-distance-i</metric>
    <metric>forager-energy-ui</metric>
    <metric>forager-energy-i</metric>
    <metric>total-steps-taken</metric>
    <metric>number-tr</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="0.9"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="all-infected_covary" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-food-visits-returned-ui</metric>
    <metric>total-num-food-visits-returned-i</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-foraging-distance-ui</metric>
    <metric>total-foraging-distance-i</metric>
    <metric>forager-energy-ui</metric>
    <metric>forager-energy-i</metric>
    <metric>total-steps-taken</metric>
    <metric>number-tr</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="1"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="distance-SA-covary" repetitions="50" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-food-visits-returned-ui</metric>
    <metric>total-num-food-visits-returned-i</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-foraging-distance-ui</metric>
    <metric>total-foraging-distance-i</metric>
    <metric>forager-energy-ui</metric>
    <metric>forager-energy-i</metric>
    <metric>total-steps-taken</metric>
    <metric>number-tr</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="walk-SA">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-SA">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="leading-SA">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disappointment-SA">
      <value value="600"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-SA">
      <value value="14"/>
      <value value="16"/>
      <value value="20"/>
      <value value="24"/>
      <value value="26"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.5"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="angle-SA-covary" repetitions="50" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-food-visits-returned-ui</metric>
    <metric>total-num-food-visits-returned-i</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-foraging-distance-ui</metric>
    <metric>total-foraging-distance-i</metric>
    <metric>forager-energy-ui</metric>
    <metric>forager-energy-i</metric>
    <metric>total-steps-taken</metric>
    <metric>number-tr</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="walk-SA">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="leading-SA">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disappointment-SA">
      <value value="600"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-SA">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-SA">
      <value value="21"/>
      <value value="24"/>
      <value value="30"/>
      <value value="36"/>
      <value value="39"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.5"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="walk-SA-covary" repetitions="50" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-food-visits-returned-ui</metric>
    <metric>total-num-food-visits-returned-i</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-foraging-distance-ui</metric>
    <metric>total-foraging-distance-i</metric>
    <metric>forager-energy-ui</metric>
    <metric>forager-energy-i</metric>
    <metric>total-steps-taken</metric>
    <metric>number-tr</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="leading-SA">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disappointment-SA">
      <value value="600"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-SA">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-SA">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="walk-SA">
      <value value="0.56"/>
      <value value="0.64"/>
      <value value="0.8"/>
      <value value="0.96"/>
      <value value="1.04"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.5"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="dis-SA-covary" repetitions="50" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-food-visits-returned-ui</metric>
    <metric>total-num-food-visits-returned-i</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-foraging-distance-ui</metric>
    <metric>total-foraging-distance-i</metric>
    <metric>forager-energy-ui</metric>
    <metric>forager-energy-i</metric>
    <metric>total-steps-taken</metric>
    <metric>number-tr</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="leading-SA">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disappointment-SA">
      <value value="420"/>
      <value value="480"/>
      <value value="600"/>
      <value value="720"/>
      <value value="780"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-SA">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-SA">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="walk-SA">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.5"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="leading-SA-covary" repetitions="50" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="5400"/>
    <metric>nest-energy</metric>
    <metric>ind-ant-times-visited</metric>
    <metric>total-num-food-visits</metric>
    <metric>total-num-food-visits-returned</metric>
    <metric>total-num-food-visits-returned-ui</metric>
    <metric>total-num-food-visits-returned-i</metric>
    <metric>total-num-ants-visited</metric>
    <metric>total-num-active-ants</metric>
    <metric>total-foraging-distance</metric>
    <metric>total-foraging-distance-ui</metric>
    <metric>total-foraging-distance-i</metric>
    <metric>forager-energy-ui</metric>
    <metric>forager-energy-i</metric>
    <metric>total-steps-taken</metric>
    <metric>number-tr</metric>
    <enumeratedValueSet variable="number-of-scouts">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reorient-tick">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-leaving">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="leading-SA">
      <value value="0.175"/>
      <value value="0.2"/>
      <value value="0.25"/>
      <value value="0.3"/>
      <value value="0.325"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disappointment-SA">
      <value value="600"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-SA">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="angle-SA">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="walk-SA">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cost-of-infection">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="0.995"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="disease-prevalence">
      <value value="0.5"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="0"/>
      </enumeratedValueSet>
    </subExperiment>
    <subExperiment>
      <enumeratedValueSet variable="cost-perception-distance">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-perception-angle">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-walk-speed">
        <value value="0"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-leading">
        <value value="1"/>
      </enumeratedValueSet>
      <enumeratedValueSet variable="cost-disappointment">
        <value value="1"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
