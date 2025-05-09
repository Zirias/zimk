PATH=$(command -p getconf PATH)
mode="644"
case "${1}" in
    -m*) mode="${1#-m}"; shift; break;;
    *) break;;
esac
cp "${1}" "${2}"
case "$(file "${2}")" in
    *directory*) chmod "${mode}" "${2}/$(basename "${1}")"; break;;
    *) chmod "${mode}" "${2}"; break;;
esac
