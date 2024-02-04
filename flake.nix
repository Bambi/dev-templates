{
  description = "A collection of flake templates";

  outputs = { self }: {

    templates = {

      dpdk = {
        path = ./dpdk;
        description = "DPDK development";
      };
    };

    defaultTemplate = self.templates.dpdk;
  };
}
