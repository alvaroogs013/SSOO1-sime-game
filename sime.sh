#!/bin/bash

#========================
#DECLARACION DE VARIABLES
#========================

#Declaracion de las cartas
KS=0.5 #Rey
QS=0.5 #Caballo
JS=0.5 #Sota
FS=0 #Figura cualquiera entre 1 y 7
SIETEYMEDIA=7.5
#Contadores control de cartas
CONT[1]=0
CONT[2]=0
CONT[3]=0
CONT[4]=0
CONT[5]=0
CONT[6]=0
CONT[7]=0
CONT8=0
CONT9=0
CONT10=0

# Contadores monedas jugadores 
CONTMONEDA[1]=$MONEDAS
CONTMONEDA[2]=$MONEDAS
CONTMONEDA[3]=$MONEDAS
CONTMONEDA[4]=$MONEDASBANCA
i=1
#Contadores de los puntos de los jugadores
JUG[1]=0
JUG[2]=0
JUG[3]=0
JUG[4]=0 # BANCA
BANCA=4
#FLAGS que determinan si un jugador se planta(1) o no(0)
PLANTA[1]=0
PLANTA[2]=0
PLANTA[3]=0
PLANTA[$BANCA]=0 #BANCA
JUGADORES_PLANTADOS=0 # Contabiliza el numero de jugadores que se han plantado
#FLAGS que determinan si un jugador se pasa de 7.5 puntos: si se pasa FLAG=1, si no FLAG=0
EXCEDE[1]=0
EXCEDE[2]=0
EXCEDE[3]=0
EXCEDE[$BANCA]=0
JUGADORES_EXCEDIDOS=0
#Contadores rondas ganadas
GANARONDASBANCA=0
GANABANCA=0
NUMSIETE=0
NUMSIETEBANCA=0
PORCIENTO=100


#========================
#DECLARACION DE FUNCIONES
#========================

#--------------------
#FUNCIONES AUXILIARES
#--------------------

function reset_contadores
{
	CONT[1]=0
	CONT[2]=0
	CONT[3]=0
	CONT[4]=0
	CONT[5]=0
	CONT[6]=0
	CONT[7]=0
	CONT8=0
	CONT9=0
	CONT10=0

	JUG[1]=0
	JUG[2]=0
	JUG[3]=0
	JUG[$BANCA]=0 # BANCA

	PLANTA[1]=0
	PLANTA[2]=0
	PLANTA[3]=0
	PLANTA[$BANCA]=0 #BANCA
	JUGADORES_PLANTADOS=0 # Contabiliza el numero de jugadores que se han plantado

	EXCEDE[1]=0
	EXCEDE[2]=0
	EXCEDE[3]=0
	EXCEDE[$BANCA]=0
	JUGADORES_EXCEDIDOS=0
}

function leer_configuracion
{
	i=1
	while read linea
		do
		   echo "$linea" >> PAL$i.cfg

			i=$((i+1))

		done < "config.cfg"

		read JUGADORES < PAL1.cfg
		echo "${JUGADORES:10}" >> JUGADORES.txt
		read JUGADORES < JUGADORES.txt

		read MONEDASBANCA < PAL2.cfg
		echo "${MONEDASBANCA:13}" >> MONEDASBANCA.txt
		read MONEDASBANCA < MONEDASBANCA.txt
		
		read MONEDAS < PAL3.cfg
		echo "${MONEDAS:8}" >> MONEDAS.txt
		read MONEDAS < MONEDAS.txt
		
		read APUESTA < PAL4.cfg
		echo "${APUESTA:8}" >> APUESTA.txt
		read APUESTA < APUESTA.txt
		
		read FICHERO < PAL5.cfg
		echo "${FICHERO:11}" >> FICHERO.txt
		read FICHERO < FICHERO.txt
		
		rm -f JUGADORES.txt
		rm -f MONEDASBANCA.txt
		rm -f MONEDAS.txt
		rm -f APUESTA.txt
		rm -f FICHERO.txt
		rm -f PAL1.cfg
		rm -f PAL2.cfg
		rm -f PAL3.cfg
		rm -f PAL4.cfg
		rm -f PAL5.cfg
}



function reparte
{
	# Se reparte una carta al jugador que se pasa a la funcion en el primer parámetro
	RAND=$((($RANDOM%10)+1)) #la carta es un numero del 1 al 10
	# Comprobamos de que carta se trata
	if test $RAND -eq 10 # Si se trata de un rey
	then
		JUG[$1]=`echo "$KS+${JUG[$1]}" | bc` #Se añade la puntuacion de la carta al jugador
		
		CONT10=$(($CONT10+1)) # Se contabiliza el numero de cartas del mismo valor que han salido
		
		if test $CONT10 -gt 4 # Se comprueba que la carta no ha salido mas de 4 veces, y si es asi se genera otro numero aleatorio
		then
			RAND=$((($RANDOM%10)+1))
		fi
	fi 
	if test $RAND -eq 9 # Si se trata de un caballo
	then
		JUG[$1]=`echo "$QS+${JUG[$1]}" | bc` # Se añade la puntuacion de la carta al jugador
		CONT9=$(($CONT9+1)) # Se contabiliza el numero de cartas del mismo valor que han salido
		
		if test $CONT9 -gt 4 # Se comprueba que la carta no ha salido mas de 4 veces, y si es asi se genera otro numero aleatorio
		then
			RAND=$((($RANDOM%10)+1))
		fi
	fi
	if test $RAND -eq 8 # Si se trata de una sota
	then
		JUG[$1]=`echo "$JS+${JUG[$1]}" | bc` # Se añade la puntuacion de la carta al jugador
		CONT8=$(($CONT8+1)) # Se contabiliza el numero de cartas del mismo valor que han salido
		
		if test $CONT8 -gt 4 # Se comprueba que la carta no ha salido mas de 4 veces, y si es asi se genera otro numero aleatorio
		then
			RAND=$((($RANDOM%10)+1))
		fi
	fi
	if test $RAND -le 7 # Si se trata de una carta con valor 1-7
	then
		JUG[$1]=`echo "$RAND+${JUG[$1]}" | bc` # Se añade la puntuacion de la carta al jugador
		CONT[$RAND]=$((${CONT[$RAND]}+1))  #Se contabiliza el numero de cartas del mismo valor que han salido
		
		if test $((${CONT[$RAND]}+1)) -gt 4 # Se comprueba que la carta no ha salido mas de 4 veces, y si es asi se genera otro numero aleatorio
		then
			RAND=$((($RANDOM%10)+1))
		fi
	fi
}


function datos_jugador
{
	if test $1 -eq $BANCA
	then
		echo ===BANCA===
		echo Puntuacion actual: ${JUG[$1]}
		echo carteraBanca: ${CONTMONEDA[$1]}
		echo 
		echo
	else
		echo ===Jugador $1===
		echo Puntuacion actual: ${JUG[$1]}
		echo cartera: ${CONTMONEDA[$1]}
		echo 
		echo
	fi
}

function muestra_datos
{
	if test $JUGADORES -eq 1 
		then
		datos_jugador 1
		datos_jugador 4
		fi
		if test $JUGADORES -eq 2
		then 
		datos_jugador 1
		datos_jugador 2
		datos_jugador 4
		fi
		if test $JUGADORES -eq 3
		then
		datos_jugador 1
		datos_jugador 2
		datos_jugador 3
		datos_jugador 4 #BANCA
		fi
}

function muestra_monederos
{
	JUGA=1
	while test $JUGA -le $(($JUGADORES+1))
	do
		if test $JUGA -ne $(($JUGADORES+1))
		then
			echo
			echo Jugador$JUGA:
			echo ---------
			echo Monedas jugador$JUGA: ${CONTMONEDA[$JUGA]}
		else
			echo
			echo Banca
			echo -----
			echo Monedas banca: ${CONTMONEDA[$BANCA]}
		fi
		JUGA=$(($JUGA+1))
	done
}


function pide_jugador
{
	JUGA=1
	clear
	echo
	if test ${PLANTA[$1]} -eq 0 -a ${EXCEDE[$1]} -eq 0
	then
		if test $1 -eq $BANCA
		then
			echo =========
			echo   BANCA
			echo =========
		else	
			echo ==========
			echo Jugador $1
			echo ==========
		fi
		echo Puntuacion actual: ${JUG[$1]}
		echo ¿Desea una carta adicional?\(S/N\):
		read ELECCION 
		# Switch que evalua la eleccion del usuario y llama a las principales funciones
		case $ELECCION in
			s | S)
				reparte $1
				COMPROBACION=$(($(echo "if (${JUG[$1]}>$SIETEYMEDIA) 1" | bc)+0))
				if test 1 -eq $COMPROBACION #En caso de que el jugador al que se está repartiendo se haya pasado 
				then
					if test $1 -eq $BANCA
					then 
						# Si la banca pierde, se reparte a cada jugador la apuesta, si un jugador se pasa antes que la banca esta gana su apuesta
						CONTMONEDA[4]=$((${CONTMONEDA[$1]}-$APUESTA*$JUGADORES))
						JUGA=1
						while test $JUGA -le $JUGADORES
						do
							if test ${EXCEDE[$JUGA]} -eq 0 #Si el jugador no se habia pasado antes
							then
								CONTMONEDA[$JUGA]=$((${CONTMONEDA[$JUGADOR]}+$APUESTA))
							fi
							JUGA=$(($JUGA+1))
						done
						
						echo Puntuacion actual banca: ${JUG[$1]}
						echo LA BANCA PIERDE!
						echo
						echo Monedero actual banca: ${CONTMONEDA[$1]}
						echo
						read -p "Pulse INTRO para continuar"
						clear
						EXCEDE[$BANCA]=1
				else
						CONTMONEDA[$BANCA]=$((${CONTMONEDA[$BANCA]}+$APUESTA))
						CONTMONEDA[$1]=$((${CONTMONEDA[$1]}-$APUESTA))
						echo Puntuacion actual: ${JUG[$1]}
						echo TE PASASTE, QUÈ MALA SUERTE!
						echo
						echo Monedero actual: ${CONTMONEDA[$1]}
						echo
						read -p "Pulse INTRO para continuar"
						clear
						EXCEDE[$1]=1
						JUGADORES_EXCEDIDOS=$(($JUGADORES_EXCEDIDOS+1))
					fi
				fi
			;;
			n | N)
				echo
				echo Te has plantado
				PLANTA[$1]=1
				JUGADORES_PLANTADOS=$(($JUGADORES_PLANTADOS+1))
			;;
			*)
				echo ERROR: opcion incorrecta.
				sleep 1
				pide_jugador $1
			;;
		esac
		
	fi
}




function comprueba_puntos
{
	clear
	echo =================
	echo =RONDA TERMINADA=
	echo =================
	echo VAMOS A COMPROBAR LOS PUNTOS:
	JUGA=1
	if test ${EXCEDE[$BANCA]} -eq 0
	then
		while test $JUGA -le $(($JUGADORES))
		do
			if test ${EXCEDE[$JUGA]} -eq 0 #Si el jugador no se ha pasado
			then 
				if test ${PLANTA[$JUGA]} -eq 1 # Si el jugador se ha plantado
				then
					echo Jugador$JUGA:
					echo ---------
					echo Puntos jugador$JUGA: ${JUG[$JUGA]}
					echo Puntos banca: ${JUG[$BANCA]}
					COMPROBACION1=$(($(echo "if (${JUG[$JUGA]}>${JUG[$BANCA]}) 1" | bc)+0))
					COMPROBACION2=$(($(echo "if (${JUG[$JUGA]}<${JUG[$BANCA]}) 1" | bc)+0))
					if test 1 -eq $COMPROBACION1
					then
						echo EL JUGADOR $JUGA GANA A LA BANCA ¡ENHORABUENA JUGADOR $JUGA\!
						COMPROBACION=$(($(echo "if (${JUG[$JUGA]}==$SIETEYMEDIA) 1" | bc)))
						if test 1 -eq $COMPROBACION
						then
							echo EL JUGADOR $JUGA HA OPTENIDO 7.5 PUNTOS, LA APUESTA SE DOBLA
							CONTMONEDA[$JUGA]=$((${CONTMONEDA[$JUGA]}+$((2*$APUESTA))))
							CONTMONEDA[$BANCA]=$((${CONTMONEDA[$BANCA]}-$((2*$APUESTA))))
							NUMSIETE=$(($NUMSIETE+1))
						else
							CONTMONEDA[$JUGA]=$((${CONTMONEDA[$JUGA]}+$APUESTA))
							CONTMONEDA[$BANCA]=$((${CONTMONEDA[$BANCA]}-$APUESTA))
						fi
					elif test 1 -eq $COMPROBACION2
					then	
						echo LA BANCA GANA AL JUGADOR $JUGA
						COMPROBACION=$(($(echo "if (${JUG[$BANCA]}==$SIETEYMEDIA) 1" | bc)+0))
						if test 1 -eq $COMPROBACION
						then
							echo LA BANCA HA OPTENIDO 7.5 PUNTOS, LA APUESTA SE DOBLA
							CONTMONEDA[$BANCA]=$((${CONTMONEDA[$BANCA]}+$((2*$APUESTA))))
							CONTMONEDA[$JUGA]=$((${CONTMONEDA[$JUGA]}-$((2*$APUESTA))))
							GANARONDASBANCA=$(($GANARONDASBANCA+1))
							NUMSIETEBANCA=$(($NUMSIETEBANCA+1))
						else
							CONTMONEDA[$BANCA]=$((${CONTMONEDA[$BANCA]}+$APUESTA))
							CONTMONEDA[$JUGA]=$((${CONTMONEDA[$JUGA]}-$APUESTA))
							GANARONDASBANCA=$(($GANARONDASBANCA+1))
						fi
					else
						echo IGUALDAD DE PUNTOS, LA BANCA GANA LA APUESTA
						COMPROBACION=$(($(echo "if (${JUG[$JUGA]}==$SIETEYMEDIA) 1" | bc)+0))
						if test 1 -eq $COMPROBACION
						then
							echo IGUALDAD A 7.5, LA APUESTA SE DOBLA 
							CONTMONEDA[$BANCA]=$((${CONTMONEDA[$BANCA]}+$((2*$APUESTA))))
							CONTMONEDA[$JUGA]=$((${CONTMONEDA[$JUGA]}-$((2*$APUESTA))))
							GANARONDASBANCA=$(($GANARONDASBANCA+1))
							NUMSIETE=$(($NUMSIETE+1))
							NUMSIETEBANCA=$(($NUMSIETEBANCA+1))
						else
							CONTMONEDA[$BANCA]=$((${CONTMONEDA[$BANCA]}+$APUESTA))
							CONTMONEDA[$JUGA]=$((${CONTMONEDA[$JUGA]}-$APUESTA))
							GANARONDASBANCA=$(($GANARONDASBANCA+1))
						fi
					fi
					echo Monedas jugador$JUGA: ${CONTMONEDA[$JUGA]}
					echo Monedas banca: ${CONTMONEDA[$BANCA]}
					echo ------------------------------
				
				fi
			else
				echo Jugador$JUGA:
				echo ---------
				echo Puntos jugador$JUGA: ${JUG[$JUGA]}
				echo Puntos banca: ${JUG[$BANCA]}
				echo EL JUGADOR SE HA PASADO CON ${JUG[$JUGA]}, LA BANCA HA GANADO: $APUESTA MONEDAS
				echo Monedas jugador$JUGA: ${CONTMONEDA[$JUGA]}
				echo Monedas banca: ${CONTMONEDA[$BANCA]}
				echo ------------------------------
			fi
			JUGA=$(($JUGA+1))
		done
	elif test ${EXCEDE[$BANCA]} -eq 1 #Si la ronda se terminó porque la banca se pasó de puntos
	then
		echo LA BANCA SE HA PASADO, CADA JUGADOR GANA: $APUESTA MONEDAS
		echo ----------------------------------------------------
		JUGA=1
		while test $JUGA -le $(($JUGADORES+1))
		do
			if test ${EXCEDE[$JUGA]} -eq 0 #Si el jugador no se habia pasado antes
			then	
				echo
				if test $JUGA -ne $(($JUGADORES+1))
				then
					echo Jugador$JUGA:
					echo ---------
					echo Monedas jugador$JUGA: ${CONTMONEDA[$JUGA]}
				else
					echo Banca
					echo -----
					echo Monedas banca: ${CONTMONEDA[$BANCA]}
				fi
			else
				echo Jugador$JUGA:
				echo ---------
				echo EL JUGADOR SE PASÓ ANTES, LA BANCA GANA SU APUESTA:
				echo Monedas jugador$JUGA: ${CONTMONEDA[$JUGA]}
					
			fi
			JUGA=$(($JUGA+1))
		done
	elif test $JUGADORES_EXCEDIDOS -eq $(($JUGADORES))  # Si todos los jugadores se han excedido
	then
		muestra_monederos
	fi
	echo
	read -p "Pulse INTRO para continuar"
}

function reset
{

	leer_configuracion
	
	CONTMONEDA[1]=$MONEDAS
	CONTMONEDA[2]=$MONEDAS
	CONTMONEDA[3]=$MONEDAS
	CONTMONEDA[4]=$MONEDASBANCA

	JUG[1]=0
	JUG[2]=0
	JUG[3]=0
	JUG[4]=0
	
	GANARONDASBANCA=0
	GANABANCA=0
	NUMSIETE=0
	NUMSIETEBANCA=0


}



#----------------------
#FUNCIONES PRINCIPALES
#----------------------
function configuracion
{
	clear
	echo Has entrado en CONFIGURACION
	echo
	SALIR=1
	while  test "$SALIR" != N 
	do
		echo      CONFIGURACION:
		rm -f aux1.cfg #ficheros auxiliares para cambiar cada parametro de la configuracion
		rm -f aux2.cfg #una vez usados se borran
		rm -f aux3.cfg
		rm -f aux4.cfg
		rm -f aux5.cfg
		SALIR=1
		i=1
		while read linea
		do
			
			echo "$linea" >> aux$i.cfg
			i=$((i+1))
		done < "config.cfg"
		cat -n config.cfg
		echo Elija la opcion que desea cambiar \(1, 2, 3, 4, 5 salir:6 \)
		OPCION=0
		while test $OPCION -ne 1  -a  $OPCION -ne 2  -a  $OPCION -ne 3 -a $OPCION -ne 4 -a $OPCION -ne 5 -a $OPCION -ne 6
		do
			read OPCION
			if test  $OPCION -ne 1  -a  $OPCION -ne 2  -a  $OPCION -ne 3 -a $OPCION -ne 4 -a $OPCION -ne 5 -a $OPCION -ne 6
			then
				echo Error, introduzca otra opcion:
			fi
		done
		#ANALISIS DE LAS OPCIONES 1, 2, 3, 4, 5 y 6
		if test $OPCION -eq 1 #Cambiar el numero de jugdores
		then
			VALOR=4
			while test  $VALOR -ne 1  -a  $VALOR -ne 2  -a  $VALOR -ne 3 
			do
				echo Selecciona el numero de jugadores \(1, 2, 3\)
				read VALOR
				if test $VALOR -ne 1  -a  $VALOR -ne 2  -a  $VALOR -ne 3 
				then
		 			echo Error: Valor incorrecto:
				fi
			done
			echo
			echo JUGADORES=$VALOR
			rm -f aux1.cfg
			echo JUGADORES=$VALOR >> aux1.cfg
			
		elif test $OPCION -eq 2 #Cambiar las monedas de la banca
		then
			VALOR1=0
			while test $VALOR1 -lt 6  -o  $VALOR1 -gt 20
			do
				echo Introduce el numero de monedas de la banca \(entre 6 y 20\)
				read VALOR1
				if test $VALOR1 -lt 6  -o  $VALOR1 -gt 20 
				then
					echo Error: Valor incorrecto
				fi	
			done	
			echo
			echo MONEDASBANCA=$VALOR1
			rm -f aux2.cfg
			echo MONEDASBANCA=$VALOR1 >> aux2.cfg

		elif test $OPCION -eq 3 #Cambiar las monedas de cada jugador
		then
			VALOR2=0
			while test $VALOR2 -lt 1 -o $VALOR2 -gt 10
			do
				echo Introduce el numero de monedas de cada jugador \(entre 1 y 10\)
				read VALOR2
				if test $VALOR2 -lt 1 -o $VALOR2 -gt 10
				then
					echo Error: Valor incorrecto
				fi
				
			done
			echo
			echo MONEDAS=$VALOR2
			rm -f aux3.cfg
			echo MONEDAS=$VALOR2 >> aux3.cfg
		
		elif test $OPCION -eq 4
		then
			VALOR3=0
			while test $VALOR3 -lt 1 -o $VALOR3 -gt 5
			do
				echo Introduce el valor de la apuesta de cada ronda \(entre 1 y 5\)
				read VALOR3
				if test $VALOR3 -lt 1 -o $VALOR3 -gt 5
				then
					echo Error: Valor incorrecto
				fi
			done
			echo
			echo APUESTA=$VALOR3
			rm -f aux4.cfg
			echo APUESTA=$VALOR3 >> aux4.cfg
		
		elif test $OPCION -eq 5 #Nombre del fichero de partida
		then
			echo Introduce el nombre del historial de partida \(sin .log\):
			read FICHERO 
			rm -f aux5.cfg
			echo FICHEROLOG=$FICHERO.log >> aux5.cfg
			
		else test $OPCION -eq 6 #Salir de la configuracion
			echo Saliendo de la configuración...
			SALIR=N
		fi
		rm -f config.cfg
		cat aux1.cfg >> config.cfg
		cat aux2.cfg >> config.cfg
		cat aux3.cfg >> config.cfg
		cat aux4.cfg >> config.cfg
		cat aux5.cfg >> config.cfg
		echo
		
		rm -f aux1.cfg
		rm -f aux2.cfg
		rm -f aux3.cfg
		rm -f aux4.cfg
		rm -f aux5.cfg
		
		while test  "$SALIR" != S  -a  "$SALIR" != N   
		do
			echo Desea seguir en la configuracion? \(S / N\)
			read SALIR
			SALIR=$(echo $SALIR | tr 's,n' 'S,N') #Convertir una letra a mayusculas
			if test "$SALIR" != S  -a  "$SALIR" != N
			then
			 	echo Opcion no valida, introduce \(S / N\)
			fi
			clear
			
		done 
	done
	menu # Llamada a la función menu tras la ejecucion de configuracion
}

function jugar
{
	leer_configuracion
	CONTMONEDA[1]=$MONEDAS
	CONTMONEDA[2]=$MONEDAS
	CONTMONEDA[3]=$MONEDAS
	CONTMONEDA[4]=$MONEDASBANCA
	SEGUNDOSTOTAL2=0
	
	clear
	echo ========================
	echo =JUEGO DE LAS 7 Y MEDIA=
	echo ========================
	echo
	echo
	MINUTO=`date +"%M"`
	SEGUNDO=`date +"%S"`
	MINUTOSEGUNDOS=$((10#$MINUTO*60))
	SEGUNDOSTOTAL=$((10#$SEGUNDO+$MINUTOSEGUNDOS))
	RONDA=0
	FLAG=0 #Variable que va adeterminar cuando se acaba una ronda
	while test $FLAG -eq 0 # Este es el bucle que se encarga del control de las rondas
	do
		RONDA=$(($RONDA+1))
		# PONEMOS TODOS LOS CONTADORES A 0
		reset_contadores
		clear
		# COMIEZA LA RONDA
		# SE REPARTE UNA CARTA A CADA JUGADOR Y A LA BANCA
		echo =================
		echo =Ronda numero: $RONDA=
		echo =================
		echo El valor de la apuesta es: $APUESTA
		echo ----------------------------
		JUGADOR=1
		echo
		echo ===REPARTO INCICIAL DE CARTAS===
		echo 
		while test $JUGADOR -le $JUGADORES # Este bucle se encarga del reparto de una carta a cada jugador
		do
			reparte $JUGADOR # Se hace una llamada a la fucion reparte y se indica el jugador a repartir la carta a traves de la variable JUGADOR
			JUGADOR=$(($JUGADOR+1)) # Se incrementa la variable jugador para que en la proxima iteracion se reparta la carta al siguente jugador
		done
		# Se reparte una carta a la banca (jugador 4 siempre):
		reparte $BANCA # BANCA=4
		
		# Se muestra por pantalla los datos de los jugadores mediante la funcion muestra_datos
		muestra_datos
		
		# Meter una peticion de pulsar una tecla para continuar, acto seguido se va preguntando a cada jugador que desea hacer
		read -p "Pulse INTRO para continuar"
		clear
		# Peticiones de a jugadores
		FLAG2=0
		FLAG3=0
		while test $FLAG2 -eq 0 # Este bucle se encarga del control de los turnos
		do
			clear
			JUGADOR=1
			while test $JUGADOR -le $(($JUGADORES+1)) -a $FLAG3 -eq 0
			do 
				if test $JUGADOR -eq $(($JUGADORES+1)) # Si se trata del ultimo jugador, se reparte a la banca
				then
					pide_jugador $BANCA # Se hace una llamada a la fucion reparte y se indica el jugador a repartir la carta a traves de la variable JUGADOR
				else # Si no se trata del ultimo jugador, se reparte al jugador correspondiente
					pide_jugador $JUGADOR # Se hace una llamada a la fucion reparte y se indica el jugador a repartir la carta a traves de la variable JUGADOR
				fi
				
				# Condiciones que hacen que se acaben los turnos: si todos los jugadores se plantan, si todos los jugadores se pasan, si la banca se pasa.
				if test $JUGADORES_PLANTADOS -eq $(($JUGADORES+1-$JUGADORES_EXCEDIDOS)) -o $JUGADORES_EXCEDIDOS -eq $(($JUGADORES)) -o ${EXCEDE[$BANCA]} -eq 1
				then
					FLAG2=1
					FLAG3=1
				fi
				
				JUGADOR=$(($JUGADOR+1)) # Se incrementa la variable jugador para que en la proxima iteracion se reparta la carta al siguente jugador
			done
			
		done
		comprueba_puntos
		
		# Condiciones que hacen terminar la ronda: (la ronda alguno de los jugadores o la banca se quede sin monedas suficientes para afrontar una nueva ronda)
		JUGADOR=1
		while test $JUGADOR -le $(($JUGADORES+1))
		do 
			if test ${CONTMONEDA[$JUGADOR]} -lt $(($APUESTA*2))
			then
				FLAG=1
				GANABANCA=1
			fi
			JUGADOR=$(($JUGADOR+1))
		done
		if test ${CONTMONEDA[$BANCA]} -lt $(($JUGADORES*$APUESTA*2))
		then
			GANABANCA=0
			FLAG=1
		fi
		
	done
	clear
	echo ===================
	echo =FIN DE LA PARTIDA=
	echo ===================
	echo
	#Se muestra un mesaje con los jugadores que han perdido
	PERDEDOR=1
	JUGADOR=1
	while test $JUGADOR -le $(($JUGADORES+1))
	do 
		if test ${CONTMONEDA[$JUGADOR]} -lt ${CONTMONEDA[$PERDEDOR]}
		then
			PERDEDOR=$JUGADOR
		fi
		JUGADOR=$(($JUGADOR+1))
	done
	echo ------------------------------
	if test $PERDEDOR -eq $BANCA
	then
		echo LA BANCA HA PERDIDO LA PARTIDA
	else
		echo El JUGADOR $PERDEDOR HA PERDIDO LA PARTIDA
	fi
	echo ------------------------------
	muestra_monederos
	
	rm -f DATOS.txt
	#Se acttualizan los datos del fichero .log
	FECHA=`date +"%D"`
	HORA=`date +"%H:%M"`
	MINUTO2=`date +"%M"`
	SEGUNDO2=`date +"%S"`
	MINUTOSEGUNDO2=$((10#$MINUTO2*60))
	SEGUNDOSTOTAL2=$((10#$SEGUNDO2+$MINUTOSEGUNDO2))
	TIEMPOPARTIDA=$(($SEGUNDOSTOTAL2-$SEGUNDOSTOTAL))
	
					
	if test $JUGADORES -eq 1
	then 
		echo "$FECHA|$HORA|$JUGADORES|$MONEDAS|$MONEDASBANCA|$APUESTA|${CONTMONEDA[1]}|*|*|${CONTMONEDA[$BANCA]}|$TIEMPOPARTIDA|$RONDA|$GANARONDASBANCA|$GANABANCA|$NUMSIETE|$NUMSIETEBANCA" >> $FICHERO
	elif test $JUGADORES -eq 2
	then
		echo "$FECHA|$HORA|$JUGADORES|$MONEDAS|$MONEDASBANCA|$APUESTA|${CONTMONEDA[1]}|${CONTMONEDA[2]}|*|${CONTMONEDA[$BANCA]}|$TIEMPOPARTIDA|$RONDA|$GANARONDASBANCA|$GANABANCA|$NUMSIETE|$NUMSIETEBANCA" >> $FICHERO
	elif test $JUGADORES -eq 3
	then
		echo "$FECHA|$HORA|$JUGADORES|$MONEDAS|$MONEDASBANCA|$APUESTA|${CONTMONEDA[1]}|${CONTMONEDA[2]}|${CONTMONEDA[3]}|${CONTMONEDA[$BANCA]}|$TIEMPOPARTIDA|$RONDA|$GANARONDASBANCA|$GANABANCA|$NUMSIETE|$NUMSIETEBANCA" >> $FICHERO
		
	fi
	#Escribir en fichero log
	echo FIN DE LA PARTIDA...
	reset
	read -p "Pulse INTRO para continuar"
	menu
	
}

function estadisticas
{

	clear
	echo ============================
	echo =ESTADÍSTICAS DE LA PARTIDA=
	echo ============================
	
	leer_configuracion
	if test -f $FICHERO
	then
		#Hago los calculos de las estadisticas
		#Leo el numero de partidas
		wc -l <$FICHERO >> partidas.log #Se cuenta el numero de lineas (partidas)
		read PARTIDAS < partidas.log
		rm -f partidas.log
		if test $PARTIDAS -ne 0
		then
			
			
			#Media de las apuestas
			SUMAPUESTAS=0
			for APUESTA in `cut -d "|" -f 6 $FICHERO`
			do
				SUMAPUESTAS=$(($SUMAPUESTAS+$APUESTA))
			done
			MEDIAPUESTAS=`echo "scale=2; $SUMAPUESTAS/$PARTIDAS" | bc`
			
			#Media de las rondas jugadas
			SUMRONDAS=0
			for RONDA in `cut -d "|" -f 12 $FICHERO`
			do
				SUMRONDAS=$(($SUMRONDAS+$RONDA))
			done
			MEDIARONDAS=`echo "scale=2; $SUMRONDAS/$PARTIDAS" | bc`
			
			#Tiempo total de todas las partidas
			SUMTIEMPO=0
			for TIEMPO in `cut -d "|" -f 11 $FICHERO`
			do
				SUMTIEMPO=$(($SUMTIEMPO+$TIEMPO))
			done
			#Media de los tiempos de las partidas
			MEDIATIEMPOS=`echo "scale=2; $SUMTIEMPO/$PARTIDAS" | bc`
			
			#Media de los monederos de los jugadores
			SUMMONEDEROS=0
			for MONEDERO in `cut -d "|" -f 4 $FICHERO`
			do
				SUMMONEDEROS=$(($SUMMONEDEROS+$MONEDERO))
			done
			MEDIAMONEDEROS=`echo "$SUMMONEDEROS/$PARTIDAS" | bc`

			#Media de las monedas de la banca
			SUMMONEDASBANCA=0
			for MONEDEROBANCA in `cut -d "|" -f 5 $FICHERO`
			do
				SUMMONEDASBANCA=$(($SUMMONEDASBANCA+$MONEDEROBANCA))
			done
			MEDIABANCA=`echo "scale=2; $SUMMONEDASBANCA/$PARTIDAS" | bc`
			
			#Porcentaje de veces que ganan los jugadores respecto a la banca
			SUMGANABANCA=0
			for GBANCA in `cut -d "|" -f 14 $FICHERO`
			do
				SUMGANABANCA=$(($SUMGANABANCA+$GBANCA))
			done
			PORCENTAJEBANCA=`echo "scale=2; $SUMGANABANCA/$PARTIDAS" | bc`
			PORCENTAJEJ=`echo "scale=2; 1-$PORCENTAJEBANCA" | bc`
			PORCENTAJEJUGADOR=`echo " $PORCENTAJEJ*$PORCIENTO" | bc`
			
			#Porcentaje de veces que la banca o algun jugador obtuvo siete y media
			SUMSYM=0
			for SYM in `cut -d "|" -f 15 $FICHERO`
			do
				SUMSYM=$(($SUMSYM+$SYM))
			done
			PORCENTAJESYM=`echo "scale=2; $SUMSYM/$PARTIDAS" | bc`
			PORCENTAJESIETEYMEDIA=`echo " $PORCENTAJESYM*$PORCIENTO" | bc`
			
			
			echo ------------------------------------------------------------------
			echo Número total de partidas jugadas: $PARTIDAS
			echo Media de las apuestas:  $MEDIAPUESTAS
			echo Media de rondas de las partidas jugadas: $MEDIARONDAS 
			echo Media de los tiempos de todas las partidas jugadas: $MEDIATIEMPOS 
			echo Media de los monederos de los jugadores en la partida: $MEDIAMONEDEROS
			echo Media de las monedas de la banca: $MEDIABANCA
			echo Tiempo total invertido en todas las partidas: $SUMTIEMPO s 
			echo Porcentaje de veces que ganan los jugadores respecto a la banca: $PORCENTAJEJUGADOR% 
			echo Porcentaje de veces que la banca o algun jugador obtuvo siete y media: $PORCENTAJESYM%
			echo ------------------------------------------------------------------  
		else
			echo ERROR: No se ha jugado todavía ninguna partida
		fi
	else
		echo ERROR: No se ha jugado ninguna partida todavía
	fi
	
	read -p "Pulse INTRO para continuar"
	clear
	menu
					
	
}

function clasificacion
{
	clear
	echo ================
	echo =CLASIFICACION=
	echo ================
	#Leo el numero de partidas
	leer_configuracion
	if test -f $FICHERO
	then
		wc -l <$FICHERO >> partidas.log #Se cuenta el numero de lineas (partidas)
		read PARTIDAS < partidas.log
		rm -f partidas.log
		if test $PARTIDAS -ne 0
		then
			#Calculo partida mas corta 
			PCORTA=10000
			CORTA=0
			for TIEMPO in `cut -d "|" -f 11 $FICHERO`
			do
				if test $PCORTA -ge $TIEMPO
				then
					PCORTA=$TIEMPO
					CORTA=$(($CORTA+1))
				fi
			done
			
			#Calculo de la partida mas larga FUNCIONA
			PLARGA=1
			LARGA=0
			for TIEMPO in `cut -d "|" -f 11 $FICHERO`
			do
				if test $PLARGA -le $TIEMPO
				then
					PLARGA=$TIEMPO
					LARGA=$(($LARGA+1))
				fi
			done
			
			#Calculo de la partida con mas rondas 
			MASRONDAS=0
			CONTRONDAS=0
			for RONDAS in `cut -d "|" -f 12 $FICHERO`
			do
				if test $MASRONDAS -le $RONDAS
				then
					MASRONDAS=$RONDAS
					CONTRONDAS=$(($CONTRONDAS+1))
				fi
			done
			
			#Calculo de la partida con menos rondas 
			MENOSRONDAS=10000
			CONTRONDASMIN=0
			for RONDAS in `cut -d "|" -f 12 $FICHERO`
			do
				if test $MENOSRONDAS -ge $RONDAS
				then
					MENOSRONDAS=$RONDAS
					CONTRONDASMIN=$(($CONTRONDASMIN+1))
				fi
			done
			
			#Calculo de la partida con mayor apuesta 
			MAYORAPUESTA=1
			CONTAPUESTA=0
			for APUESTA in `cut -d "|" -f 6 $FICHERO`
			do
				if test $MAYORAPUESTA -le $APUESTA
				then
					MAYORAPUESTA=$APUESTA
					CONTAPUESTA=$(($CONTAPUESTA+1))
				fi
			done
			
			#Calculo de la partida en la que la banca finaliza con mas monedas 
			MAXBANCA=1
			CONTMAXBANCA=0
			for MONEDEROBANCA in `cut -d "|" -f 10 $FICHERO`
			do
				if test $MAXBANCA -le $MONEDEROBANCA
				then 
					MAXBANCA=$MONEDEROBANCA
					CONTMAXBANCA=$(($CONTMAXBANCA+1))
				fi
			done
			
			#Calculo de la partida en la que uno de los jugadores acaba con mas monedas
			MAXJUGADOR=1
			MAXJUGADOR2=1
			MAXJUGADOR3=1
			CONTMAXJUG=0
			CONTMAXJUG2=0
			CONTMAXJUG3=0
			CONTFINAL=0
			if test $JUGADORES -eq 1
			then
				for MONEDEROS in `cut -d "|" -f 7 $FICHERO`
				do
					if test $MAXJUGADOR -le $MONEDEROS
					then 
						MAXJUGADOR=$MONEDEROS
						CONTMAXJUG=$(($CONTMAXJUG+1))
					fi
				done
				CONTFINAL=$CONTMAXJUG
			elif test $JUGADORES -eq 2
			then
				for MONEDEROS in `cut -d "|" -f 7 $FICHERO`
				do
					if test $MAXJUGADOR -le $MONEDEROS
					then 
						MAXJUGADOR=$MONEDEROS
						CONTMAXJUG=$(($CONTMAXJUG+1))
					fi
				done
				for MONEDEROS2 in `cut -d "|" -f 8 $FICHERO`
				do
					if test $MAXJUGADOR2 -le $MONEDEROS2
					then
						MAXJUGADOR2=$MONEDEROS2
						CONTMAXJUG2=$(($CONTMAXJUG2+1))
					fi 
				done
				if test $MAXJUGADOR -gt $MAXJUGADOR2
				then
					CONTFINAL=$CONTMAXJUG
				else 
					CONTFINAL=$CONTMAXJUG2
				fi	
			elif test $JUGADORES -eq 3
			then
				for MONEDEROS in `cut -d "|" -f 7 $FICHERO`
				do
					if test $MAXJUGADOR -le $MONEDEROS
					then 
						MAXJUGADOR=$MONEDEROS
						CONTMAXJUG=$(($CONTMAXJUG+1))
					fi
				done
				for MONEDEROS2 in `cut -d "|" -f 8 $FICHERO`
				do
					if test $MAXJUGADOR2 -le $MONEDEROS2
					then
						MAXJUGADOR2=$MONEDEROS2
						CONTMAXJUG2=$(($CONTMAXJUG2+1))
					fi 
				done 
				for MONEDEROS3 in `cut -d "|" -f 9 $FICHERO`
				do
					if test $MAXJUGADOR3 -le $MONEDEROS3
					then
						MAXJUGADOR3=$MONEDEROS3
						CONTMAXJUG3=$(($CONTMAXJUG3+1))
					fi
				done
				if test $MAXJUGADOR -gt $MAXJUGADOR2 -a $MAXJUGADOR -gt $MAXJUGADOR3
				then
					CONTFINAL=$CONTMAXJUG
				elif test $MAXJUGADOR2 -gt $MAXJUGADOR -a $MAXJUGADOR2 -gt $MAXJUGADOR3
				then
					CONTFINAL=$CONTMAXJUG2
				elif test $MAXJUGADOR3 -gt $MAXJUGADOR -a $MAXJUGADOR3 -gt $MAXJUGADOR2
				then
					CONTFINAL=$CONTMAXJUG3
				fi
			fi
		
			clear
			
		#En este documento se mostraran las estadisticas por pantalla.
			echo ------------------------------------------------------------------
			
			echo ------------------------------------------------------------------
			echo Formato de los datos:
			echo FECHA\|HORA\|JUGADORES\|MONEDAS\|MONEDASBANCA\|APUESTA\|MONEDASJUG1\|MONEDASJUG2\|MONEDASJUG3\|MONEDASBANCA\|TIEMPOPARTIDA\|RONDAS\|RONDASGANABANCA\|GANABANCA\|NUMSIETE\|NUMSIETEBANCA
			
			echo Datos de la partida mas corta:
			sed -n $CORTA'p' $FICHERO
			echo
			echo Datos de la partida mas larga:
			sed -n $LARGA'p' $FICHERO
			echo
			echo Datos de la partida con mas rondas:
			sed -n $CONTRONDAS'p' $FICHERO
			echo
			echo Datos de la partida con menos rondas:
			sed -n $CONTRONDASMIN'p' $FICHERO
			echo
			echo Datos de la partida con mayor apuesta: 
			sed -n $CONTAPUESTA'p' $FICHERO
			echo
			echo Datos de la partida en la que la banca finalizo con mas monedas:
			sed -n $CONTMAXBANCA'p' $FICHERO
			echo
			echo Datos de la partida en la que uno de los jugadores ha finalizado con más monedas: 
			sed -n $CONTFINAL'p' $FICHERO
			echo ------------------------------------------------------------------ 
		fi
	else
		echo ERROR: No se ha jugado ninguna partida todavía
	fi
		read -p "Pulse INTRO para continuar"
	clear
	menu
}

function salir
{
	echo HASTA PRONTO! :\);
	exit;
}

#Funcion de menú(sin parametros de entrada)
function menu
{
	# Mostreo del menu por pantalla
	clear
	echo ==========================================
	echo =BIENVENID@ AL JUEGO DE LAS SIETE Y MEDIA= 
	echo ==========================================
	echo MENU:
	echo  C\)CONFIGURACION;
	echo  J\)JUGAR;
	echo  E\)ESTADISTICAS;
	echo  F\)CLASIFICACION;
	echo  S\)SALIR;
	echo INTRODUZCA UNA OPCION: 
	read
	OPCION=$REPLY;
	
	# Switch que evalua la eleccion del usuario y llama a las principales funciones
	case $OPCION in
	c | C)
		configuracion; # LLamada a la función de configuración
	;;
	j | J)
		jugar;         # Llamada a la función de jugar
	;;
	e | E)
		estadisticas;  # Llamada a la función de estadísticas
	;;
	f | F)
		clasificacion; # Llamada a la función de clasificación
	;;
	s | S)
		salir;        # Llamada a la función de salida
	;;
	*)
	echo OPCIÓN INCORRECTA;
	sleep 1;
	menu;
esac 
}
#===============================================================================================
#MAIN: Contiene las comprobaciones necesarias para que el programa pueda funcionar sin problemas 
#===============================================================================================
if test -f config.cfg 
then	
	if test $# -gt 1   # Si el se pasa más de un argumento
	then
		echo ERROR, uso correcto: ./shime.sh [-g]\(argumento opcional.\);

	elif test $1 = -g  # Si el argumento es -g (Mostreo de los creadores)
	then 
		echo Creadores:;
		echo - Alvaro García Sánchez. 70924450V;
		echo - Carlos Blázquez Martín. 70837164Q;
	elif test $# -eq 0 # Si no se pasan argumentos (Ejecucion normal)
	then
		menu;      # Llamada a la funcion del menu:
	else
		echo ERROR, argumento incorrecto.; 
		echo Argumento valido: -g;
	fi
else
	echo Error: No se ha encontrado el fichero de configuración \(config.cfg\);
fi


