#!/bin/bash
echo "
#!/bin/bash
ss -anptu | grep ':80' | wc -l " > test.sh

