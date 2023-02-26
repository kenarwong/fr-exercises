#!/bin/bash
# randomizer les elements d'une phrase francaise

# elements
sujet=(je tu il elle on nous vous ils elles)
adverbe=('---' deja souvent non jamais plus '"sans doute"' '"probablement"' '"régulièrement"')
modal=(devoir pouvoir vouloir savoir faire '"se faire"')
modal_prob=5 # probabilité d'occurence

# verbe
verbe=(donner parler discuter demander vendre acheter servir)

# verbe indirect
verbe_ind_types=(verbe_ind verbe_ind_non_tonique)
verbe_ind=(penser '"se fier"' "s'intéresser" '"se méfier"' '"être fier"' '"se soucier"' '"se souvenir"') 
# verbe indirect qui ne peut pas utiliser un pronom tonique
verbe_ind_non_tonique=(réfléchir renvoyer '"se servir"' '"se lasser"' "s'apercevoir" '"se passer"' '"se tromper"')

# COD
cod=('"livre"' '"lettre"')

# COD 
# types présentatifs de COD 
# défini et indéfini ont les modification différentes
cod_presentatif=(défini indéfini)
longueur_cod_presentatif=${#cod_presentatif[@]}
cod_presentatif_def=(singulier pluriel number tous)
cod_presentatif_indef=(singulier pluriel number seul autre "d'autres" '"un peu"')

# associer types présentatifs à son sa liste corréspondante
declare -A cod_presentatif_mod 
cod_presentatif_mod[0,0]=${cod_presentatif[0]} # défini : cod_presentatif_def
cod_presentatif_mod[0,1]=cod_presentatif_def[@]
cod_presentatif_mod[1,0]=${cod_presentatif[1]} # indéfini : cod_presentatif_indef
cod_presentatif_mod[1,1]=cod_presentatif_indef[@]

# COI
# pour verbe indirect : ajouter coi_tonique à la liste de COD, coi_tout 
coi_tonique=(moi toi lui nous vous eux)
coi_tout=("${cod[@]}" "${coi_tonique[@]}")

# associer chaque type de verbe indirect à sa liste de COI corréspondante
declare -A verbe_ind_coi 
verbe_ind_coi[0,0]=${verbe_ind_types[0]}[@] # verbe_ind : tous les CODs + COI tonique
verbe_ind_coi[0,1]=coi_tout[@]
verbe_ind_coi[1,0]=${verbe_ind_types[1]}[@] # verbe_ind_non_tonique : seulement COD
verbe_ind_coi[1,1]=cod[@]
longueur_verbe_ind_types=${#verbe_ind_types[@]}

temps=(present pc imparfait pqp '"futur proche"' '"futur simple"' '"futur antérieur"' '"cond prés"' '"cond passé"')

# exercice mode
#RANDOM=$(date +%s)
t_mode=true
t_interval=30

# type d'exercice
options=(pronom indirect)
longueur_options=${#options[@]}
declare -A types 
types[0,0]=${options[0]}
types[0,1]='element_pronom_select'
types[1,0]=${options[1]}
types[1,1]='element_indirect_select'
#echo "${types[0,0]} ${types[0,1]}"
#echo "${types[1,0]} ${types[1,1]}"

rand_elem(){
  arr=("$@")
  size=${#arr[@]}
  index=$(($RANDOM % $size))
  echo ${arr[$index]}
}

rand_num(){
  echo $(((RANDOM % ${1}) + 1))
}

cod_presentatif_format(){
  # calculer le présentatif et la modification list
  index_cod_presentatif=$(($RANDOM % $longueur_cod_presentatif))
  cod_presentatif_mod_val=${cod_presentatif_mod[$index_cod_presentatif,0]}
  
  # générer la valeur de la modification
  cod_presentatif_mod_liste=${cod_presentatif_mod[$index_cod_presentatif,1]}
  cod_presentatif_mod_elem=$(rand_elem "${!cod_presentatif_mod_liste}")

  if [ "$cod_presentatif_mod_elem" = 'number' ] ; then
    rand_num=$(rand_num 1000)
    printf "COD: %s %s %d \n" "${1}" "$cod_presentatif_mod_val" $rand_num
  else
    printf "COD: %s %s %s \n" "${1}" "$cod_presentatif_mod_val" "$cod_presentatif_mod_elem"
  fi 
} >&2

verbe_format(){
  if [ "$(rand_num $modal_prob)" = 1 ] ; then
    modal_elem=$(rand_elem "${modal[@]}")
    printf "Verbe: %s %s \n" "$modal_elem" "${1}"
  else
    printf "Verbe: %s \n" "${1}"
  fi 
} >&2

element_pronom_select(){
  subj_elem=$(rand_elem "${sujet[@]}")
  adverbe_elem=$(rand_elem "${adverbe[@]}")
  verbe_elem=$(rand_elem "${verbe[@]}")
  temps_elem=$(rand_elem "${temps[@]}")
  cod_elem=$(rand_elem "${cod[@]}")
  coi_elem=$(rand_elem "${coi_tonique[@]}")
  echo Sujet: $subj_elem
  $(cod_presentatif_format "$cod_elem")
  echo COI: $coi_elem
  $(verbe_format "$verbe_elem")
  echo Temps: $temps_elem
  echo Adverbe: $adverbe_elem
} >&2

element_indirect_select(){
  index_verbe_ind=$(($RANDOM % $longueur_verbe_ind_types))
  verbe_ind_list=${verbe_ind_coi[$index_verbe_ind,0]}
  verbe_ind_coi_list=${verbe_ind_coi[$index_verbe_ind,1]}

  subj_elem=$(rand_elem "${sujet[@]}")
  adverbe_elem=$(rand_elem "${adverbe[@]}")
  verbe_elem=$(rand_elem "${!verbe_ind_list}")
  temps_elem=$(rand_elem "${temps[@]}")
  coi_elem=$(rand_elem "${!verbe_ind_coi_list}")
  echo Sujet: $subj_elem
  echo COI: $coi_elem
  echo Verbe: $verbe_elem
  echo Temps: $temps_elem
  echo Adverbe: $adverbe_elem
} >&2

exercice(){
  index_exercice=$(($RANDOM % $longueur_options))
  type_exercice=${types[$index_exercice,1]}
  command='$("${type_exercice}")'
  eval "$command"
} >&2

while :
do
  read -p "Mode chronométré? (y): " -n1 timed
  echo
  if [ 'y' != $timed ] ; then
    t_mode=false
    echo "-----------------------------------------------"
    echo "---------------En mode standard----------------"
    echo "-----------------------------------------------"
    echo
  else
    echo "-----------------------------------------------"
    echo "-------------En mode chronométré---------------"
    echo "-----------------------------------------------"
    echo
  fi 
  break
done

while :
do
  echo "-----------------------------------------------"
  echo "--Formulez la phrase en utilisant les pronoms--"
  echo "-----------------------------------------------"
  echo

  $(exercice)

  echo
	echo "--Appuyer [CTRL+C] pour terminer--"

  if [ "$t_mode" = true ] ; then
    for (( c=$t_interval; c>=0; c-- ))
    do
      echo -en '\rTime remaining: '$c'.'
     sleep 1
    done
  else
    read -rsp $'--Appuyer sur n\'importe quelle touche pour continuer--\n' -n1 key
  fi

  echo
done
