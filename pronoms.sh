#!/bin/bash
# randomizer les elements d'une phrase francaise

# elements
sujet=(je tu il elle on nous vous ils elles)
adverbe=('---' deja souvent non jamais plus)

verbe=(donner parler discuter dire demander acheter servir)
verbe_ind=(penser '"se fier"' "s'intéresser" '"se méfier"' '"être fier"' '"se soucier"' '"se souvenir"') 
verbe_ind_non_tonique=(réfléchir renvoyer '"se servir"' '"se lasser"' "s'apercevoir" '"se passer"' '"se tromper"')
verbe_ind_types=('verbe_ind' 'verbe_ind_non_tonique')

cod=('"le livre"' '"la lettre"' '"les livres"' '"les lettres"' '"un livre"' '"16 livres"' '"un lettre"' '"16 lettres"')
coi_tonique=(moi toi lui nous vous eux)
coi_tout=("${cod[@]}" "${coi_tonique[@]}")

declare -A verbe_ind_coi 
verbe_ind_coi[0,0]=${verbe_ind_types[0]}[@]
verbe_ind_coi[0,1]=coi_tout[@]
verbe_ind_coi[1,0]=${verbe_ind_types[1]}[@]
verbe_ind_coi[1,1]=cod[@]
longueur_verbe_ind_types=${#verbe_ind_types[@]}

temps=(present pc imparfait pqp '"futur proche"' '"futur simple"' '"futur antérieur"' '"cond prés"' '"cond passé"')

# exercice mode
#RANDOM=$(date +%s)
t_mode=true
t_interval=30

# type d'exercice
options=('pronom' 'indirect')
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

element_pronom_select(){
  subj_elem=$(rand_elem "${sujet[@]}")
  adverbe_elem=$(rand_elem "${adverbe[@]}")
  verbe_elem=$(rand_elem "${verbe[@]}")
  temps_elem=$(rand_elem "${temps[@]}")
  cod_elem=$(rand_elem "${cod[@]}")
  coi_elem=$(rand_elem "${coi_tonique[@]}")
  echo Sujet: $subj_elem
  echo COD: $cod_elem
  echo COI: $coi_elem
  echo Verbe: $verbe_elem
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
