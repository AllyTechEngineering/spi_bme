// bme280_spi.c
#include <stdio.h>
#include <stdint.h>
#include <periphery/spi.h>

#define BME280_CHIP_ID_REG 0xD0
// gcc -shared -o libbme280_spi.so -fPIC bme280_spi.c -lperiphery
int get_bme280_id(const char *spi_device, uint8_t *chip_id) {
    spi_t spi;
    uint8_t tx_buf[2] = {BME280_CHIP_ID_REG | 0x80, 0x00}; // Read command
    uint8_t rx_buf[2] = {0};

    if (spi_open(&spi, spi_device, 0, 500000, 0, 8, 0) < 0) {
        perror("spi_open");
        return -1;
    }

    if (spi_transfer(&spi, tx_buf, rx_buf, 2) < 0) {
        perror("spi_transfer");
        spi_close(&spi);
        return -1;
    }

    *chip_id = rx_buf[1];

    spi_close(&spi);
    return 0;
}