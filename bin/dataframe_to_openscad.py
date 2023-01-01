'''
Generate pin and probe list from a configuration
'''

import jinja2
import pandas
import click
import logging
import spreadsheet_wrangler
import os


probe_template = jinja2.Template('''/* x, y, socket/base, class*/
function get_design_probes(ground_height = -1, signal_height_dz = -0.5, power_height_dz = -1) = [
    {% for line in lines -%}
    [{{line.x}}, {{line.y}}, "{{line.socket}}", {{line.class}}],  //  {{line["net"]}} {{line["ref des"]}}
    {% endfor -%}
];
''')


pin_template = jinja2.Template('''/* x, y, type */
function get_design_pins(pin_depth = -2) = [
    {% for line in lines -%}
    [{{line.x}}, {{line.y}}, "{{line.type}}", pin_depth],
    {% endfor -%}
];
''')

pressure_pin_template = jinja2.Template('''/* x, y, [hole diameter, tip diameter, base diameter, taper length] */
function get_pressure_pins(pin_depth = -2) = [
    {% for line in lines -%}
    [{{line.x}}, {{line.y}}, [{{line.type}}]],
    {% endfor -%}
];
''')


@click.command(help="Takes a PCB & configuration data in mm, sets rotation and location on a new pcb")
@click.option("--probes", type=str, required=False, help="Spreadsheet configuration file for probes")
@click.option("--alignment-pins", type=str, required=False, help="Spreadsheet configuration file for alignment pins")
@click.option("--pressure-pins", type=str, required=False, help="Spreadsheet configuration file for pressure pins")
@click.option("--debug", is_flag=True, help="")
def main(probes, alignment_pins, pressure_pins, debug):
    logging.basicConfig()
    logging.getLogger().setLevel(logging.INFO)
    if debug:
        logging.getLogger().setLevel(logging.DEBUG)

    for template, out, fin in [
            [probe_template, "probes.scad", probes],
            [pin_template, "alignment-pins.scad", alignment_pins],
            [pressure_pin_template, "pressure-pins.scad", pressure_pins]]:

        if fin is None:
            continue
        df = spreadsheet_wrangler.read_file_to_df(fin)
        lines = [line for _, line in df.iterrows()]
        string = template.render(lines=lines)

        with open(out, 'w') as f:
            f.write(string)

if __name__ == "__main__":
    main()
