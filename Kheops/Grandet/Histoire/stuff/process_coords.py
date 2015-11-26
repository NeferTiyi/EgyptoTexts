#!/usr/bin/env python
# -*-coding:utf-8 -*

# import sys
# import os.path
import argparse

# Command line arguments
# ======================
parser = argparse.ArgumentParser()
parser.add_argument("file_in", help="Input file")
args = parser.parse_args()

file_in  = args.file_in

file_out = file_in.split(".")[0] + "_out." + file_in.split(".")[1]

print file_in
print file_out

with open(file_in, "r") as f_in :
  read_data = f_in.readlines()

f_out = open(file_out, "w")

for line in read_data :
  line = line.replace(",", " , ").replace("(", " ( ")\
             .replace(")", " ) ").replace(";", " ; ")
  fields = line.split()

  prevfield = ""

  f_out.write(4*"  ")

  for field in fields :
    if field.strip() == "(" or \
       field.strip() == ")" or \
       field.strip() == ";" or \
       field.strip() == "," :
      f_out.write(field)
    elif field.strip() == ".." :
      f_out.write(" %s" % field)
    elif field.strip().isalpha() or \
         field.strip() == "--" :
      f_out.write(" %s " % field)
    else :
      try :
        val = float(field)
      except ValueError as rc :
        exit(1)
      if prevfield == "(" :
        f_out.write("%7.2f" % val)
      elif prevfield == "," :
        f_out.write("%7.2f" % -val)
      else :
        print "Problème !"
    prevfield = field

  f_out.write("\n")

f_out.close()
