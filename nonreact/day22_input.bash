sed 's#/dev/grid/node-##g; s#-# #g; s#x##g; s#y##g; s#T##g' day22_input.txt | \
  awk '{print $1" "$2" "$3" "$4" "$5}' | egrep -v '(File|root)'
