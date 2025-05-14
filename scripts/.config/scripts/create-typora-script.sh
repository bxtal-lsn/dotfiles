#!/bin/bash
cat > /usr/local/bin/typora << 'EOF'
#!/bin/bash
"/mnt/c/Program Files/Typora/Typora.exe" "$@" > /dev/null 2>&1 &
EOF

chmod +x /usr/local/bin/typora

