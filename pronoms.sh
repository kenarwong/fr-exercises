#!/bin/bash
# randomizer les elements d'une phrase francaise

# elements
sujet=(je tu il elle on nous vous ils elles)
adverbe=('---' deja souvent non jamais plus)
verbe=(donner parler demander acheter servir )
verbe_pronomonial=('"se souvenir"' '"se servir"' '"se lasser"' "s'apercevoir")
temps=(present pc imparfait pqp '"futur proche"' '"futur simple"' '"futur antérieur"' '"cond prés"' '"cond passé"')
cod=('"le livre"' '"la lettre"' '"les livres"' '"les lettres"' '"un livre"' '"16 livres"' '"un lettre"' '"16 lettres"')
coi=(moi toi lui nous vous eux)

# exercice mode
#RANDOM=$(date +%s)
t_mode=true
t_interval=30

# type d'exercice
options=('pronom' 'pronominal')
longueur_options=${#options[@]}
declare -A types types[0,0]=${options[0]}
types[0,1]='element_pronom_select'
types[1,0]=${options[1]}
types[1,1]='element_pronominal_select'
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
  coi_elem=$(rand_elem "${coi[@]}")
  echo Sujet: $subj_elem
  echo COD: $cod_elem
  echo COI: $coi_elem
  echo Verbe: $verbe_elem
  echo Temps: $temps_elem
  echo Adverbe: $adverbe_elem
} >&2

element_pronominal_select(){
  subj_elem=$(rand_elem "${sujet[@]}")
  adverbe_elem=$(rand_elem "${adverbe[@]}")
  verbe_elem=$(rand_elem "${verbe_pronomonial[@]}")
  temps_elem=$(rand_elem "${temps[@]}")
  cod_elem=$(rand_elem "${cod[@]}")
  echo Sujet: $subj_elem
  echo COD: $cod_elem
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
