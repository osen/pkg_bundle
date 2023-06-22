cd "${prefix}"
cc -opatch-icu "${standalone_prefix}/hacks/patch-icu.c"
./patch-icu

cc -opatch-unveil "${standalone_prefix}/hacks/patch-unveil.c"
./patch-unveil

mkdir etc/firefox
echo "disable" > etc/firefox/pledge.main
echo "disable" > etc/firefox/pledge.content
echo "disable" > etc/firefox/pledge.socket
echo "disable" > etc/firefox/pledge.rdd
echo "disable" > etc/firefox/pledge.utility
echo "disable" > etc/firefox/unveil.main
echo "disable" > etc/firefox/unveil.content
echo "disable" > etc/firefox/unveil.utility
echo "disable" > etc/firefox/unveil.socket
echo "disable" > etc/firefox/unveil.rdd
