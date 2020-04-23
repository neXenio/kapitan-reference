local service_components = import './service_components.libsonnet';
local kap = import 'lib/kap.libsonnet';
local p = kap.parameters;

local manifest_set_by_service = {
  [service_name]:
    local service_component = service_components[service_name];
    local jinja_context = { service_component: service_component,
                            inventory: p};
  { 'readme.md': kap.jinja2_template('templates/docs/service_component.md.j2', jinja_context)}
  for service_name in std.objectFields(service_components)
};

local manifest_groups = [
  {
    ['%s-%s' % [service_name, manifest_name]]: manifest_set_by_service[service_name][manifest_name]
    for manifest_name in std.objectFields(manifest_set_by_service[service_name])
  }
  for service_name in std.objectFields(manifest_set_by_service)
];

kap.utils.mergeObjects(manifest_groups) + {
  # see https://github.com/deepmind/kapitan/issues/491
  fixme: {}
}
