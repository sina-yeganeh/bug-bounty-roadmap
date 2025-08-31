import os
import sys
import logging
import subprocess

def is_root():
  if os.getuid() != 0:
    return 0
  return 1

def run_script(script_name: str):
  subprocess.run(f"bash ./scripts/{script_name}")

if __name__ == "__main__":
  logger = logging.getLogger(__name__)
  logging.basicConfig(filename="./log/firewall.log", level=logging.INFO)

  if not is_root:
    logger.error("Run script as root")
    sys.exit()

  logger.info("Starting firewall ...")

  # ------------------------ Init
  tables = ["filter"]
  with open("./data/iptables-config", "w") as config:
    for table in tables:
      result = subprocess.run(["iptables", "-L", "-t", table], 
                              stdout=subprocess.PIPE)
      if result != "":
        config.write(result)
        logging.info(f"Saved {table} table")

  try:
    logger.info("Initialling firewall ...")
    run_script("firewall_init.sh")
  except Exception as err:
    logger.error(f"Could not init the firewall {err}")

  # ------------------------ Configuration
  logger.info("Configurate firewall ...")
  run_script("firewall_config.sh")

  logger.info("Firewall configuration set successfuly")