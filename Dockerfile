# Start with a recent NVIDIA PyTorch image as the base
FROM nvcr.io/nvidia/pytorch:24.05-py3

# Set environment variables to prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# === Install Base System Dependencies ===
RUN apt-get update && apt-get install -y --no-install-recommends \
    zsh \
    git \
    curl \
    ca-certificates \
    wget \
    unzip \
    build-essential \
    cmake \
    npm \
    fzf \
    ripgrep \
    gpg \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# === Install Modern CLI Replacements via APT ===
RUN mkdir -p /etc/apt/keyrings && \
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" > /etc/apt/sources.list.d/gierens.list && \
    chmod 644 /etc/apt/sources.list.d/gierens.list && \
    apt-get update && \
    apt-get install -y eza

RUN apt-get install -y bat && \
    ln -s /usr/bin/batcat /usr/local/bin/bat

RUN apt-get install -y fd-find && \
    ln -s $(which fdfind) /usr/local/bin/fd

# === Install Other Development Tools ===
RUN curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh
RUN /root/.local/bin/uv pip install --system thefuck
RUN /root/.local/bin/uv pip install --system ruff
RUN wget -qO- https://github.com/starship/starship/releases/download/v1.23.0/starship-x86_64-unknown-linux-gnu.tar.gz | tar xzf - -C /usr/local/bin
RUN curl -sSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \ 
    | tar xzf - --strip-components=1 -C /usr/local

# Add zoxide and uv to the PATH
ENV PATH="/root/.local/bin:/root/.local/share/zoxide/bin:$PATH"

# === Configure Shell and Editor ===
COPY .zshrc /root/.zshrc
COPY .config/starship.toml /root/.config/starship.toml
COPY .config/nvim /root/.config/nvim

# === Bootstrap Packer and Install Plugins ===
RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    /root/.local/share/nvim/site/pack/packer/start/packer.nvim

# The "Config Swap" method to safely install plugins
RUN mv /root/.config/nvim/init.lua /root/.config/nvim/init.lua.bak && \
    mv /root/.config/nvim/after /root/.config/nvim/after.bak && \
    echo "require('paulsava.packer')" > /root/.config/nvim/init.lua && \
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' && \
    mv /root/.config/nvim/init.lua.bak /root/.config/nvim/init.lua && \
    mv /root/.config/nvim/after.bak /root/.config/nvim/after

# Set the entrypoint to Zsh, overriding the base image's startup script
ENTRYPOINT ["/bin/zsh"]
