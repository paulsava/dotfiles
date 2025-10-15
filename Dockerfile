# Base
FROM nvcr.io/nvidia/pytorch:24.05-py3

ARG LAZYGIT_VERSION="0.42.0"
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

# Use bash with pipefail for safer RUNs
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# === Base system & common CLI ===
RUN set -eux \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      zsh git curl wget unzip ca-certificates gpg \
      build-essential cmake npm \
      fzf ripgrep \
      tmux \
      bat fd-find jq \
 && rm -rf /var/lib/apt/lists/*

# === Repos: eza + Docker CLI (optional) ===
RUN set -eux \
 && mkdir -p /etc/apt/keyrings \
 # eza repo
 && wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
    | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg \
 && echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
    > /etc/apt/sources.list.d/gierens.list \
 && chmod 644 /etc/apt/sources.list.d/gierens.list \
 # Docker CLI repo
 && curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
 && chmod a+r /etc/apt/keyrings/docker.gpg \
 && bash -lc 'source /etc/os-release \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable" \
       > /etc/apt/sources.list.d/docker.list' \
 && apt-get update \
 && apt-get install -y --no-install-recommends eza docker-ce-cli \
 && rm -rf /var/lib/apt/lists/*

# === Tools from upstream releases/scripts ===
RUN set -eux \
 # lazygit
 && curl -fLo /tmp/lazygit.tgz \
      "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
 && tar -C /tmp -xf /tmp/lazygit.tgz lazygit \
 && install /tmp/lazygit /usr/local/bin \
 && rm -f /tmp/lazygit /tmp/lazygit.tgz \
 # uv (Python package manager)
 && curl -LsSf https://astral.sh/uv/install.sh | sh \
 && /root/.local/bin/uv pip install --system thefuck ruff \
 # zoxide
 && curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash \
 # Starship (pin to avoid installer quirks)
 && curl -fsSL "https://github.com/starship/starship/releases/download/v1.23.0/starship-x86_64-unknown-linux-gnu.tar.gz" \
    | tar xzf - -C /usr/local/bin \
 # Neovim (stable linux x86_64 asset name)
 && curl -fsSL "https://github.com/neovim/neovim-releases/releases/latest/download/nvim-linux-x86_64.tar.gz" \
    | tar xzf - --strip-components=1 -C /usr/local \
 # Convenience symlinks
 && ln -sf /usr/bin/batcat /usr/local/bin/bat \
 && ln -sf "$(command -v fdfind)" /usr/local/bin/fd

# Add zoxide/uv to PATH
ENV PATH="/root/.local/bin:/root/.local/share/zoxide/bin:${PATH}"

# === Dotfiles & configs ===
RUN mkdir -p /root/.config
COPY .zshrc /root/.zshrc
COPY .config/ /root/.config/
COPY .tmux.conf /root/.tmux.conf

# --- Make sure TPM path usage in tmux.conf is valid ---
# Replace any mistaken '#{TMUX_PLUGIN_MANAGER_PATH}' with a static path
# and ensure TPM is actually run from the config (required by TPM scripts).
RUN set -eux \
 && mkdir -p /root/.tmux/plugins \
 && if grep -q '#{TMUX_PLUGIN_MANAGER_PATH}' /root/.tmux.conf; then \
      sed -i "s|#\\{TMUX_PLUGIN_MANAGER_PATH\\}|~/.tmux/plugins|g" /root/.tmux.conf; \
    fi \
 && grep -q "tpm/tpm" /root/.tmux.conf || \
      printf "\n# Ensure TPM is loaded during build\nset -g @plugin 'tmux-plugins/tpm'\nrun -b '~/.tmux/plugins/tpm/tpm'\n" >> /root/.tmux.conf

# This helps TPM know where to place plugins
ENV TMUX_PLUGIN_MANAGER_PATH=/root/.tmux/plugins

# === Neovim: bootstrap packer & install plugins ===
RUN set -eux \
 && git clone --depth 1 https://github.com/wbthomason/packer.nvim \
      /root/.local/share/nvim/site/pack/packer/start/packer.nvim \
 # Temporary config swap to run packer headless
 && mv /root/.config/nvim/init.lua /root/.config/nvim/init.lua.bak \
 && mv /root/.config/nvim/after /root/.config/nvim/after.bak \
 && printf "%s\n" "require('paulsava.packer')" > /root/.config/nvim/init.lua \
 && nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' \
 && mv /root/.config/nvim/init.lua.bak /root/.config/nvim/init.lua \
 && mv /root/.config/nvim/after.bak /root/.config/nvim/after

# === Tmux plugin manager (TPM) & plugins ===
RUN set -eux \
 && git clone https://github.com/tmux-plugins/tpm /root/.tmux/plugins/tpm \
 # Start a server with *your* config loaded so TPM can read plugin list
 && tmux -f /root/.tmux.conf start-server \
 && /root/.tmux/plugins/tpm/bin/install_plugins \
 && tmux kill-server || true

# Default shell
ENTRYPOINT ["/bin/zsh"]

