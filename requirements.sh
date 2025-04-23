#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counter for errors
ERRORS=0

# Function to print status message
print_status() {
    echo -e "${BLUE}[*] $1${NC}"
}

# Function to print success message
print_success() {
    echo -e "${GREEN}[+] $1${NC}"
}

# Function to print error message
print_error() {
    echo -e "${RED}[-] $1${NC}"
    ((ERRORS++))
}

# Function to print warning message
print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    print_error "This script must be run as root (sudo)"
    exit 1
fi

# Function to check if a command exists
check_command() {
    if ! command -v $1 &> /dev/null; then
        print_error "Command $1 not found"
        return 1
    fi
    return 0
}

# Function to install packages with error handling
install_package() {
    print_status "Installing $1..."
    if apt-get install -y $1 &> /dev/null; then
        print_success "$1 installed successfully"
        return 0
    else
        print_error "Failed to install $1"
        return 1
    fi
}

# Update package lists
print_status "Updating package lists..."
if ! apt-get update &> /dev/null; then
    print_error "Failed to update package lists"
fi

# Upgrade system packages
print_status "Upgrading system packages..."
if ! apt-get upgrade -y &> /dev/null; then
    print_warning "Failed to upgrade system packages - continuing anyway"
fi

# Install required packages
PACKAGES="aircrack-ng mdk3 python3-pip python3-venv python3-dev build-essential"
for package in $PACKAGES; do
    install_package $package
done

# Install wireless firmware packages
print_status "Installing wireless firmware packages..."
apt-get install -y linux-firmware firmware-iwlwifi firmware-realtek &> /dev/null

# Function to install Python dependencies with multiple methods
install_python_deps() {
    print_status "Installing Python dependencies..."
    
    # Method 1: Try system-wide installation first
    print_status "Attempting system-wide installation..."
    if apt-get install -y python3-psutil &> /dev/null; then
        print_success "System-wide psutil installed successfully"
        return 0
    fi
    
    # Method 2: Try pip installation without virtual environment
    print_status "Attempting pip installation..."
    if python3 -m pip install psutil &> /dev/null; then
        print_success "pip installation successful"
        return 0
    fi
    
    # Method 3: Try with virtual environment
    print_status "Creating virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
    
    print_status "Installing pip in virtual environment..."
    curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py &> /dev/null
    rm -f get-pip.py
    
    print_status "Installing psutil in virtual environment..."
    if pip install psutil &> /dev/null; then
        print_success "Virtual environment installation successful"
        deactivate
        return 0
    fi
    
    # If all methods fail
    print_error "Failed to install Python dependencies"
    return 1
}

# Configure system
configure_system() {
    print_status "Configuring system..."
    
    # Stop and disable NetworkManager
    systemctl stop NetworkManager &> /dev/null
    systemctl disable NetworkManager &> /dev/null
    
    # Kill interfering processes
    airmon-ng check kill &> /dev/null
    
    print_success "System configuration completed"
}

# Main installation process
main() {
    print_status "Checking system requirements..."
    
    # Check for required commands
    REQUIRED_COMMANDS="iw iwconfig airmon-ng airodump-ng aircrack-ng mdk3"
    for cmd in $REQUIRED_COMMANDS; do
        check_command $cmd
    done
    
    # Install Python dependencies
    install_python_deps
    
    # Configure system
    configure_system
    
    # Final status
    if [ $ERRORS -eq 0 ]; then
        print_success "Installation completed successfully!"
        print_status "Run the application with: sudo python3 WIFI_V9"
    else
        print_warning "Installation completed with $ERRORS errors"
        print_status "Please fix the errors and try again"
        print_status "You can try running: sudo apt-get install python3-psutil"
    fi
}

# Run main installation
main 