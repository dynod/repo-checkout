# Dockerfile action for repo-checkout
FROM dynod/devenv:1.3.2

COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]
