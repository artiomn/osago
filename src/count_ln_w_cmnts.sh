find . -name "*.pas" -a -not -wholename "*trash*" -exec grep -Hvc "//*" {} \;
