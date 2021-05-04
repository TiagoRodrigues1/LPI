import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'pipeVaccine'
})
export class PipeVaccinePipe implements PipeTransform {

  transform(value: unknown): unknown {
    return value ? 'Yes' : 'No'
  }

}
