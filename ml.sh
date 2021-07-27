#!/bin/bash


###### INIT/SETUP ######
# Get location of script that is controlling the mission log
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [ ! -f "$SCRIPT_DIR/todo" ] ; then
  echo "Task One" > "$SCRIPT_DIR/todo"
  echo "Task Two" >> "$SCRIPT_DIR/todo"
fi

if [ ! -f "$SCRIPT_DIR/complete" ] ; then
  echo "Completed Task" > "$SCRIPT_DIR/complete"
fi


Help()
{
   # Display Help
   echo "Syntax: ml.sh [option] [task number|task name]"
   echo "options:"
   echo "add|new|create     adds a new task to the mission log"
   echo "delete|remove      deletes task from mission log"
   echo "done|complete      marks a task as completed"
   echo "clear|clean        clears both the mission log, and the completed list"
   echo
}



# Check Parameters and execute on request 

if ([ -z "$1" ]) || ([[ "$1" == "list" ]]) ;  then
  # TODAY OUTPUT
  printf %s" MISSION LOG \n"
  printf %s"------------------------------------------\n"  
  # Get current mission log 
  LINECOUNT="$(cat $SCRIPT_DIR/todo | wc -l)"
  if [ $LINECOUNT -gt "0" ] ; 
    then
      while IFS= read -r line; do
        printf '%s\n' " ⍻ $line"
      done < "$SCRIPT_DIR/todo"
    else
      printf %s"no missions in log\n"
  fi
  # Output completed missions
  LINECOUNT="$(cat $SCRIPT_DIR/complete | wc -l)"
  if [ $LINECOUNT -gt "0" ] ;
    then
      printf %s"\n\n COMPLETED MISSIONS\n"
      printf %s"------------------------------------------"
      while IFS= read -r line; do
	 printf %s"\n ✓ $line"
      done < "$SCRIPT_DIR/complete"
  fi
  printf %s"\n\n"
elif ( [[ "$1" == "add" ]] || [[ "$1" == "new" ]] || [[ "$1" == "create" ]] ) ; then
  # create task
  NEWTASK="${@: 2}"
  echo "$NEWTASK" >> "$SCRIPT_DIR/todo"
  printf %s"New task added: $NEWTASK"

elif [[ "$1" == "done" ]] || [[ "$1" == "complete" ]] ; then
  # complete task
  TASKNO="$2"
  TASKNAME="$(sed -n ${TASKNO}p $SCRIPT_DIR/todo)"
  
  printf %s"Now finishing task: $TASKNAME"
  #remove from todo
  sed -i "${TASKNO}d" "$SCRIPT_DIR/todo"

  #add to complete list
  echo "$TASKNAME" >> "$SCRIPT_DIR/complete"

elif [[ "$1" == "delete" ]] || [[ "$1" == "remove" ]] ; then 
  TASKNO="$2"
  sed -i "${TASKNO}d" "$SCRIPT_DIR/todo"
elif  [[ "$1" == "clean" ]] || [[ "$1" == "clear" ]]  ; then
	# clear lists
  > "$SCRIPT_DIR/todo"
  > "$SCRIPT_DIR/complete"
elif [[ "$1" == "help" ]] ; then 
  Help
fi

printf %s"\n\n"
