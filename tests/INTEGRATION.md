# Integrační plán pro RHEL KVM

Na izolovaném self-hosted runneru s testovacími VM projděte: register (read-only), `original` checkpoint, standalone/backing kontrolu a SHA-256, activate z `original`, změnu uvnitř VM, `build1`, aktivaci z obou checkpointů, park/start, replace/add kolizi, úmyslně poškozený disk a full validation, ochranu checkpointu před destroy-run a prázdný Terraform plan po apply. Použijte pouze hodnoty z dočasné konfigurace; plán se v CI automaticky nespouští.
