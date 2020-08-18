# Dockerfile action for repo-checkout
FROM dynod/devenv:1.2.0

COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]
