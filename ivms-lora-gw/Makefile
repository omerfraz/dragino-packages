include $(TOPDIR)/rules.mk

PKG_NAME:=ivms-lora-gw
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=IVMS LoRa gateway (Ebyte E32 on USB) for TARGTEC
	DEPENDS:=+python-light +curl +kmod-usb-serial-ch341 +kmod-usb-serial-cp210x +kmod-usb-serial-ftdi +kmod-usb-serial-pl2303
endef

define Package/$(PKG_NAME)/description
	Claims LoRa jobs from the TARGTEC API, sends them through an E32 on a USB-serial adapter,
	and posts the trackers' "IVMS id=..." answers back. Settings: /etc/config/ivmslora.
	files/lorawan_ivms.lua is appended to admin_sensor/LoRaWAN.lua (return m, m2) by the firmware build.
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/ivmslora
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/etc/init.d $(1)/etc/config $(1)/etc/ssl/certs
	$(INSTALL_BIN) ./files/ivms-lora-gw $(1)/usr/bin/ivms-lora-gw
	$(INSTALL_BIN) ./files/ivmslora.init $(1)/etc/init.d/ivmslora
	$(INSTALL_CONF) ./files/ivmslora.config $(1)/etc/config/ivmslora
	$(INSTALL_DATA) ./files/isrg-root-x1.pem $(1)/etc/ssl/certs/isrg-root-x1.pem
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
