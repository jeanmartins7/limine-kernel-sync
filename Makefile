.PHONY: install uninstall

PACKAGE = system
TARGET = /

install:
	@echo "Installing $(PACKAGE) to $(TARGET)..."
	@sudo stow --target=$(TARGET) --dir=. --restow $(PACKAGE)
	@echo "Installation complete."

uninstall:
	@echo "Uninstalling $(PACKAGE) from $(TARGET)..."
	@sudo stow --target=$(TARGET) --dir=. --delete $(PACKAGE)
	@echo "Uninstallation complete."