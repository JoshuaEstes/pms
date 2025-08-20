# vim: set ft=sh:
# shellcheck shell=sh
####
# Plugin: kubernetes
####

# Alias for kubectl command
alias k='kubectl'

# Ensures KUBECONFIG points to the default config if not already set
kube_set_default_config() {
    if [ -z "$KUBECONFIG" ]; then
        export KUBECONFIG="$HOME/.kube/config"
    fi
}

# Prints the current Kubernetes context for use in prompts
kube_prompt_context() {
    kubectl config current-context 2>/dev/null || true
}

kube_set_default_config
