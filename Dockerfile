# Dockerfile action for repo-checkout
FROM dynod/devenv:latest

COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]
