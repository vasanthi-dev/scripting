#!/bin/bash

sample(){
  echo one
  echo two
  a=30
  echo "a in function = ${a}"
  b=20
}
a=100
echo "b in main program = ${b}"