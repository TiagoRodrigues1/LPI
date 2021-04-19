import { HttpErrorResponse } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { Clinic } from 'src/app/models/clinic.model';
import { AccountService } from 'src/app/services/account.service';
import { ClinicService } from 'src/app/services/clinic.service';

@Component({
  selector: 'app-clinic',
  templateUrl: './clinic.component.html',
  styleUrls: ['./clinic.component.css']
})
export class ClinicComponent implements OnInit {
  Clinic : Clinic[];
  s: string;
  constructor(private accountService: AccountService, private router: Router,private clinicService: ClinicService) { }

  ngOnInit(): void {
    this.clinics();
  }

  public clinics() {
    this.accountService.getClinics().subscribe(
    (response: Clinic[]) => {
      this.Clinic = response['data'];
    },
    (error: HttpErrorResponse) => {
      alert(error.message);
    }); 
  }

  goProfile(id: number, clinic: Clinic) { 
    this.router.navigate([`/clinic/${id}`],{state: {data: clinic}});
  }

}
