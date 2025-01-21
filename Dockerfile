FROM amazonlinux:2

COPY hello.sh /
RUN chmod +x /hello.sh

CMD ["/hello.sh"]
